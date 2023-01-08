# OpenMarket

- throbleShooting

1. memory leak 
detailview으로 화면전환하고 화면에서 나가도 메모리에서 지워지지 않는 문제가 있었습니다 [weak self]를 사용해 문제를해결 했습니다.
```swift
private func addSubscribers(_ id: Int) {
    productService.productPublisher
      .receive(on: DispatchQueue.main)
      .sink { [weak self] returnedProduct in
        guard let self = self else { return }
        self.product = returnedProduct
      }
      .store(in: &cancellalbes)

    $cartCount
      .map{ [weak self] in $0 * (self?.product?.discountedPrice ?? 0) }
      .sink { [weak self] totolPrice in
        self?.totolPrice = totolPrice
      }
      .store(in: &cancellalbes)

    favoriteProductService.savedEntitiesPublisher
      .debounce(for: 0.1, scheduler: RunLoop.main)
      .receive(on: RunLoop.main)
      .map { [weak self] in $0.filter { $0.productId == self?.product?.id ?? 0 } }
      .sink(receiveValue: { [unowned self] isFavorites in
        if isFavorites.isEmpty {
          self.favoriteProduct = false
        } else {
          self.favoriteProduct = true
        }
      })
      .store(in: &cancellalbes)
  }
```
2. 의존성 주입 
기존 방식대로 맨위서부터 차례대로 의존성을 주입해 가장 하단에 있는 뷰까지 도달하려다 보니까 유지보수에 자원이 많이 들어갔었습니다. 팩토리 패턴으로 문제를 해결했습니다.
```swift
 var body: some View {
    TabView(selection: $vm.currentTab) {
      viewFactory.makeHomeViewModel()
        .tag(Tab.home)
        .setUpTab()
        .ignoresSafeArea(.keyboard, edges: .bottom)
      
      
      viewFactory.makeAddProductView()
        .tag(Tab.productRegister)
        .setUpTab()
        .ignoresSafeArea(.keyboard, edges: .bottom)
      
      
      viewFactory.makeMyProductView()
        .tag(Tab.myProductList)
        .setUpTab()
        .ignoresSafeArea(.keyboard, edges: .bottom)
      
    }
```



3. coredata 시점문제
코어데이터를 활용하여 좋아하는 상품 기능을 만들었습니다 그러나 coredata Service 와 바로 바인딩을 해주었더니 coredata에 있는 정보를 바로 업데이트를 하지 않는 문제가있어 시간을 살짝 걸어주는 걸로 해결했습니다.

```swift
favoriteProductService.savedEntitiesPublisher
      .debounce(for: 0.1, scheduler: RunLoop.main)
      .receive(on: RunLoop.main)
      .map { [weak self] in $0.filter { $0.productId == self?.product?.id ?? 0 } }
      .sink(receiveValue: { [unowned self] isFavorites in
        if isFavorites.isEmpty {
          self.favoriteProduct = false
        } else {
          self.favoriteProduct = true
        }
      })
      .store(in: &cancellalbes)
```

4. flatMap 강제업래핑
Empty(completeImmediately: true).eraseToAnyPublisher() 으로 처리
```swift
extension ProductPostable {
  func postProduct(parms: ProductEncodeModel, images: [Data]) -> AnyPublisher<Data, NetworkError> {
    pageNumber = 2
    
    return openMarketNetwork.requestPublisher(.postProduct(params: parms, images: images))
      .flatMap { [weak self] _ in
        self?.openMarketNetwork.requestPublisher(.getMyProductList()) ?? Empty(completeImmediately: true).eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()
  }
}
```

5. unittest 오염성
유닛 테스트를 진행 하다 보니까 실제 서버에 테스트용 상품이 올라가서 테스트 한번하고 실제 프로젝트를 실행시켜 지우고를 반복하다 예전에 mockTest를 했었던 것이 기억이나 mock test 를 진행하기위해 기존의 싱글톤 코드를 리팩하여 의존성 주입을 하도록 변경 하여 성공과 실패 실제 Session을 주입하도록 변경 하여 유닛테스트의 오염성 문제를 해결하였습니다.
```swift
func test_ApiManager_requestPublisher_productDeletionURISearch_shouldBeWork() {
    //when
    let openMarketNetwork = ApiManager(session: mockSession)
    let expectation = XCTestExpectation(description: "productDeletionURISearch 조회")

    //then
    openMarketNetwork.requestPublisher(.productDeletionURISearch(id: 14))
      .sink(receiveCompletion: openMarketNetwork.handleCompletion) { result in
        expectation.fulfill()
      }
      .store(in: &cancellable)
    
    //given
    wait(for: [expectation], timeout: 2)
  }

```


6. URLRequestManager
URLRequset를 enum으로 만들어 편하게 사용하도록 구조를 설계 하였습니다.
```swift
enum OpenMarketRequestManager {
  
  case getProductList(page_no: Int = 1, items_per_page: Int = 20)
  case getProduct(_ id: Int)
  case postProduct(params: ProductEncodeModel, images: [Data])
  case getMyProductList(page_no: Int = 1, items_per_page: Int = 10, search_value: String = "red")
  case getSearchProductList(page_no: Int = 1, items_per_page: Int = 10, search_value: String = "")
  case productDeletionURISearch(id: Int)
  case deleteProduct(endpoint: String)
  case modifyProduct(id: Int, product: ProductEncodeModel)
  
  private var BaseURLString: String {
    return "https://openmarket.yagom-academy.kr"
  }
  
  private var endPoint: String {
    switch self {
    case .getProductList:
      return "/api/products?"
    case let .getProduct(id) :
      return "/api/products/\(id)"
    case .postProduct:
      return "/api/products"
    case .getMyProductList:
      return "/api/products?"
    case let .productDeletionURISearch(id):
      return "/api/products/\(id)/archived"
    case let .deleteProduct(endpoint):
      return "\(endpoint)"
    case let .modifyProduct(id, _):
      return "/api/products/\(id)/"
    case .getSearchProductList:
      return "/api/products?"
    }
  }
  
  private var method: HTTPMethod {
    switch self {
    case .getProductList:
      return .get
    case .getProduct:
      return .get
    case .postProduct:
      return .post
    case .getMyProductList:
      return .get
    case .productDeletionURISearch:
      return .post
    case .deleteProduct:
      return .delete
    case .modifyProduct:
      return .patch
    case .getSearchProductList:
      return .get
    }
  }
  
  private var parameters: [String: Any]? {
    switch self {
    case let .getProductList(page_no, items_per_page):
      var params: [String: Any] = [:]
      params["page_no"] = page_no
      params["items_per_page"] = items_per_page
      return params
    case .getProduct:
      return nil
    case .postProduct:
      return nil
    case let .getMyProductList(page_no, items_per_page, search_value):
      var params: [String: Any] = [:]
      params["page_no"] = page_no
      params["items_per_page"] = items_per_page
      params["search_value"] = search_value
      return params
    case .productDeletionURISearch:
      return nil
    case .deleteProduct:
      return nil
    case .modifyProduct:
      return nil
    case let .getSearchProductList(page_no, items_per_page, search_value):
      var params: [String: Any] = [:]
      params["page_no"] = page_no
      params["items_per_page"] = items_per_page
      params["search_value"] = search_value
      return params
    }
  }
  
  private var headerFields: [String: String]? {
    switch self {
    case .getProductList:
      return nil
    case .getProduct:
      return nil
    case let .postProduct(params, _):
      return ["identifier": "81da9d11-4b9d-11ed-a200-81a344d1e7cb", "Content-Type": "multipart/form-data; boundary=\(params.boundary)"]
    case .getMyProductList:
      return nil
    case .productDeletionURISearch:
      return ["identifier": "81da9d11-4b9d-11ed-a200-81a344d1e7cb", "Content-Type": "application/json"]
    case .deleteProduct:
      return ["identifier": "81da9d11-4b9d-11ed-a200-81a344d1e7cb"]
    case .modifyProduct:
      return ["identifier": "81da9d11-4b9d-11ed-a200-81a344d1e7cb", "Content-Type" : "application/json"]
    case .getSearchProductList:
      return nil
    }
  }
  
  private var bodyData: Data? {
    switch self {
    case .getProductList:
      return nil
    case .getProduct:
      return nil
    case let .postProduct(params, images):
      let paramsData = try? JSONEncoder().encode(params)
      var multipartFormParts: [Datapart] = []
      images.forEach { multipartFormParts.append(Datapart(name: "images", data: $0, filename: "", contentType: "image/jpeg"))}
      multipartFormParts.append(Datapart(name: "params", data: paramsData ?? Data(), filename: "", contentType: "application/json"))
      return MultipartForm(parts: multipartFormParts, boundary: params.boundary).bodyData
    case .getMyProductList:
      return nil
    case .productDeletionURISearch:
      return try? JSONEncoder().encode(Secret())
    case .deleteProduct:
      return nil
    case let .modifyProduct(_, product):
      return try? JSONEncoder().encode(product)
    case .getSearchProductList:
      return nil
    }
  }
  
  var urlRequest: URLRequest {
    var components = URLComponents(string: BaseURLString + endPoint)
    
    if let parameters {
      components?.queryItems = parameters.map { key, value in
        URLQueryItem(name: key, value: "\(value)")
      }
    }
    
    var request = URLRequest(url: (components?.url) ?? URL(fileURLWithPath: ""))
    request.httpMethod = method.rawValue
    
    if let headerFields {
      headerFields.forEach {
        request.addValue($0.value, forHTTPHeaderField: $0.key)
      }
    }
    
    if let bodyData  {
      request.httpBody = bodyData
    }
  
    return request
  }
}
```


7. ProductNetworkService의 기능 비대
프로토콜 확장을 통하여 기능별로 분리하였습니다.

```swift

protocol OpenMarketService: AnyObject {
  var productList: [Product] { get set }
  var productListPublisher: Published<[Product]>.Publisher { get }
  var myProductList: [Product] { get set }
  var myProductListPublisher: Published<[Product]>.Publisher { get }
  var cancellable: Set<AnyCancellable> { get set }
  var pageNumber: Int { get set }
  var openMarketNetwork: ApiManager { get }
}

extension OpenMarketService {
  var openMarketNetwork: ApiManager {
    return ApiManager(session: URLSession.shared)
  }
}

protocol ProductListGetProtocol: OpenMarketService, ProductGetable {}
protocol ProductPostProtocol: OpenMarketService, ProductPostable {}
protocol ProductEditProtocol: OpenMarketService, ProductDeleteable, ProductModifyable {}


protocol ProductModifyable: OpenMarketService {
  func modifyProduct(id: Int, product: ProductEncodeModel) -> AnyPublisher<Data, NetworkError>
}

extension ProductModifyable {
  func modifyProduct(id: Int, product: ProductEncodeModel) -> AnyPublisher<Data, NetworkError> {
    pageNumber = 2
    
    return openMarketNetwork.requestPublisher(.modifyProduct(id: id, product: product))
      .flatMap { [weak self] _ in
        self?.openMarketNetwork.requestPublisher(.getMyProductList()) ?? Empty(completeImmediately: true).eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()
  }
}


protocol ProductDeleteable: OpenMarketService {
 func deleteProduct(endPoint: String) -> AnyPublisher<Data, NetworkError>
}

extension ProductDeleteable {
  func deleteProduct(endPoint: String) -> AnyPublisher<Data, NetworkError> {
    pageNumber = 2
    
    return openMarketNetwork.requestPublisher(.deleteProduct(endpoint: endPoint))
      .flatMap { [weak self] _ in
        self?.openMarketNetwork.requestPublisher(.getMyProductList()) ?? Empty(completeImmediately: true).eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()
  }
}

protocol ProductPostable: OpenMarketService {
  func postProduct(parms: ProductEncodeModel, images: [Data]) -> AnyPublisher<Data, NetworkError>
}

extension ProductPostable {
  func postProduct(parms: ProductEncodeModel, images: [Data]) -> AnyPublisher<Data, NetworkError> {
    pageNumber = 2
    
    return openMarketNetwork.requestPublisher(.postProduct(params: parms, images: images))
      .flatMap { [weak self] _ in
        self?.openMarketNetwork.requestPublisher(.getMyProductList()) ?? Empty(completeImmediately: true).eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()
  }
}

```

8. 수정화면과 추가화면의 같은기능
프로토콜의 기본구현으로 문제를 해결하려 하였으나 observerableObject를 채택하려면 class를 사용해야하고 완전히 같은 기능을 사용해야 하므로 상속으로 중복코드 문제를 해결하였습니다.
```swift
class ProductValidationViewModel: ObservableObject {
  @Published var images: [UIImage] = []
  @Published var productName: String = ""
  @Published var price: String = ""
  @Published var discountPrice: String = ""
  @Published var stock: String = ""
  @Published var productDescription: String = ""
  @Published var informationError: String = ""
  @Published var postButtonisValid: Bool = false
  @Published var currency: Currency = .KRW
  @Published var product: ProductModel?
  var cancellable = Set<AnyCancellable>()
 
   func makeProduct() -> ProductEncodeModel {
    return ProductEncodeModel(name: productName,
                  description: discountPrice,
                  price: Int(price) ?? 1,
                  currency: currency.rawValue,
                  discountedPrice: Int(discountPrice) ?? 0,
                  stock: Int(stock) ?? 1)
  }
  
   func addSubscriber() {
    isProductInformationVailidPublisher
      .dropFirst()
      .receive(on: RunLoop.main)
      .map { informationValid in
        switch informationValid {
        case .valid:
          return ""
        case .imageEmpty:
          return "이미지를 업로드 해주세요"
        case .productCharacterRange:
          return "제품명은 3자이상 입력해 주세요"
        case .priceEmpty:
          return "가격을 입력해주세요"
        case .discountPriceOver:
          return "할인가를 수정해주세요"
        case .stockEmpty:
          return "수량을 입력해 주세요"
        case .productDescriptionCharacterRange:
          return "설명을 입력해 주세요"
        }
      }
      .sink { [weak self] returnError in
        guard let self = self else { return }
        self.informationError = returnError
      }
      .store(in: &cancellable)
    
    isFormValidPublsher
      .receive(on: RunLoop.main)
      .sink { [weak self] returnValue in
        guard let self = self else { return }
        self.postButtonisValid = returnValue
      }
      .store(in: &cancellable)
  }
  
  private var isImageCountVailidPublisher: AnyPublisher<Bool, Never> {
    $images
      .debounce(for: 0.5, scheduler: RunLoop.main)
      .map { $0.count > 0 }
      .eraseToAnyPublisher()
  }
   
  private var isProductNameVailidPublisher: AnyPublisher<Bool, Never> {
    $productName
      .debounce(for: 0.5, scheduler: RunLoop.main)
      .map { $0.count >= 3}
      .eraseToAnyPublisher()
  }
  
  private var isPriceVailidPublisher: AnyPublisher<Bool, Never> {
    $price
      .debounce(for: 0.5, scheduler: RunLoop.main)
      .map { Int($0) ?? 0 }
      .map { $0 > 0 }
      .eraseToAnyPublisher()
  }
  
  private var isDiscountPriceVailidPublisher: AnyPublisher<Bool, Never> {
    $discountPrice
      .debounce(for: 0.5, scheduler: RunLoop.main)
      .combineLatest($price)
      .map { Int($0) ?? 0 <= Int($1) ?? 0 }
      .eraseToAnyPublisher()
  }
  
  private var isStockVailidPublisher: AnyPublisher<Bool, Never> {
    $stock
      .debounce(for: 0.5, scheduler: RunLoop.main)
      .map { Int($0) ?? 0 }
      .map { $0 > 0 }
      .eraseToAnyPublisher()
  }
  
  private var isProductDescriptionVailidPublisher: AnyPublisher<Bool, Never> {
    $productDescription
      .debounce(for: 0.5, scheduler: RunLoop.main)
      .map { $0.count >= 1 }
      .eraseToAnyPublisher()
  }
  
  private var isProductInformationVailidPublisher: AnyPublisher<ProductStatus, Never> {
    let paramsOne = Publishers.CombineLatest3(isImageCountVailidPublisher, isProductNameVailidPublisher, isPriceVailidPublisher)
    let paramsTwo = Publishers.CombineLatest3(isDiscountPriceVailidPublisher, isStockVailidPublisher, isProductDescriptionVailidPublisher)
    
    return paramsOne.combineLatest(paramsTwo)
      .debounce(for: 0.5, scheduler: RunLoop.main)
      .map {
        if !$0.0 { return ProductStatus.imageEmpty }
        if !$0.1 { return ProductStatus.productCharacterRange }
        if !$0.2 { return ProductStatus.priceEmpty }
        if !$1.0 { return ProductStatus.discountPriceOver }
        if !$1.1 { return ProductStatus.stockEmpty }
        if !$1.2 { return ProductStatus.productDescriptionCharacterRange }
        return ProductStatus.valid
      }
      .eraseToAnyPublisher()
  }
  
  private var isFormValidPublsher: AnyPublisher<Bool, Never> {
    isProductInformationVailidPublisher
      .map { $0 == ProductStatus.valid }
      .eraseToAnyPublisher()
  }
}


```


