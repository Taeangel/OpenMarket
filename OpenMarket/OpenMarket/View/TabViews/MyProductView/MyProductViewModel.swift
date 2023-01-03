//
//  MyProductViewModel.swift
//  OpenMarket
//
//  Created by song on 2022/12/27.
//

import Foundation
import Combine

final class MyProductViewModel: ObservableObject {
  @Published var productList: [Product]?
  @Published var searchText: String = ""
  @Published var showAlert: Bool = false
  @Published var isPostSuccess: Bool = false
  @Published var alertMessage: String = ""
  
  var myProductListService: ProductEditProtocol
  private var cancellable = Set<AnyCancellable>()

  let openMarketNetwork = ApiManager(session: URLSession.shared)

  init(allProductListService: ProductEditProtocol) {
    self.myProductListService = allProductListService
    self.addSubscribers()
  }
  
  private func addSubscribers() {
    myProductListService.myProductListPublisher
      .receive(on: DispatchQueue.main)
      .sink { [weak self] returnedProductList in
        guard let self = self else { return }
        self.productList = returnedProductList
      }
      .store(in: &cancellable)
  }
  
  func deleteProduct(_ id: Int) {
    openMarketNetwork.requestPublisher(.productDeletionURISearch(id: id))
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        guard let self = self else { return }
        switch completion {
        case .finished:
          self.showAlert = true
          self.isPostSuccess = true
          self.alertMessage = "Delete에 성공했습니다!"
        case let .failure(error):
          self.showAlert = true
          self.isPostSuccess = false
          self.alertMessage = "\(error)가 있습니다ㅜ"
        }
      } receiveValue: { [weak self] data in
        guard let self = self else { return }
        guard let deleteURL = String(data: data, encoding: .utf8) else { return }
        self.myProductListService.deleteProduct(endPoint: deleteURL)
          .sink { _ in
            
          } receiveValue: { [weak self] returnedProductList in
            guard let self = self else { return }
            let productListModel = try? JSONDecoder().decode(ProductListModel.self, from: returnedProductList)
            self.myProductListService.myProductList = productListModel?.product ?? []
            self.listUpdata()
          }
          .store(in: &self.cancellable)
      }
      .store(in: &cancellable)
  }
  
  private func listUpdata() {
    openMarketNetwork.requestPublisher(.getProductList())
      .sink(receiveCompletion: openMarketNetwork.handleCompletion) { [weak self] returnedProductList in
        let productListModel = try? JSONDecoder().decode(ProductListModel.self, from: returnedProductList)
        self?.myProductListService.productList = productListModel?.product ?? []
      }
      .store(in: &cancellable)
  }
}
