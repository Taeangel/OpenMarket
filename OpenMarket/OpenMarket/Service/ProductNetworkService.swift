//
//  ProductListService.swift
//  OpenMarket
//
//  Created by song on 2022/12/23.
//

import Foundation
import Combine
import SwiftUI

protocol OpenMarketService {
  var productList: [Product] { get set }
  var productListPublisher: Published<[Product]>.Publisher { get }
  var myProductList: [Product] { get set }
  var myProductListPublisher: Published<[Product]>.Publisher { get }
}

protocol ProductGetable {
  func getProduct()
}

protocol ProductPostable {
  func postProduct(parms: ProductEncodeModel, images: [Data]) -> AnyPublisher<Data, NetworkError>
}

protocol ProductDeleteable {
 func deleteProduct(endPoint: String) -> AnyPublisher<Data, NetworkError>
}

protocol ProductModifyable {
  func modifyProduct(id: Int, product: ProductEncodeModel) -> AnyPublisher<Data, NetworkError>
}

protocol OpenMarketCRUDable: ProductGetable, ProductPostable, ProductDeleteable, ProductModifyable { }

protocol ProductListGetProtocol: OpenMarketService, ProductGetable {}
protocol ProductPostProtocol: OpenMarketService, ProductPostable {}
protocol ProductEditProtocol: OpenMarketService, ProductDeleteable, ProductModifyable {}

final class ProductNetworkService: ProductListGetProtocol, ProductPostProtocol, ProductEditProtocol {
  @Published var productList: [Product] = []
  var productListPublisher: Published<[Product]>.Publisher { return $productList }
  
  @Published var myProductList: [Product] = []
  var myProductListPublisher: Published<[Product]>.Publisher { return $myProductList }
  
  private var cancellable = Set<AnyCancellable>()
  
  var pageNumber = 2
  
  init() {
    initMethod()
  }
  
  private func initMethod() {
    ApiManager.shared.requestPublisher(.getProductList())
      .sink(receiveCompletion: ApiManager.shared.handleCompletion) { [weak self] returnedProductList in
        let productListModel = try? JSONDecoder().decode(ProductListModel.self, from: returnedProductList)
        self?.productList = productListModel?.pages ?? []
      }
      .store(in: &cancellable)
    
    ApiManager.shared.requestPublisher(.getMyProductList())
      .sink(receiveCompletion: ApiManager.shared.handleCompletion) { [weak self] returnedProductList in
        let productListModel = try? JSONDecoder().decode(ProductListModel.self, from: returnedProductList)
        self?.myProductList = productListModel?.pages ?? []
      }
      .store(in: &cancellable)
  }
  
  func getProduct() {
    ApiManager.shared.requestPublisher(.getProductList(page_no: pageNumber))
      .sink(receiveCompletion: ApiManager.shared.handleCompletion) { [weak self] returnedProductList in
        let productListModel = try? JSONDecoder().decode(ProductListModel.self, from: returnedProductList)
        self?.productList += productListModel?.pages ?? []
      }
      .store(in: &cancellable)
    pageNumber += 1
  }
  
  func postProduct(parms: ProductEncodeModel, images: [Data]) -> AnyPublisher<Data, NetworkError> {
    pageNumber = 2
    
    return ApiManager.shared.requestPublisher(.postProduct(params: parms, images: images))
      .flatMap { _ in
        ApiManager.shared.requestPublisher(.getMyProductList())
      }
      .eraseToAnyPublisher()
  }
  
  func deleteProduct(endPoint: String) -> AnyPublisher<Data, NetworkError> {
    pageNumber = 2
    
    return ApiManager.shared.requestPublisher(.deleteProduct(endpoint: endPoint))
      .flatMap { _ in
        ApiManager.shared.requestPublisher(.getMyProductList())
      }
      .eraseToAnyPublisher()
  }
  
  func modifyProduct(id: Int, product: ProductEncodeModel) -> AnyPublisher<Data, NetworkError> {
    pageNumber = 2
    
    return ApiManager.shared.requestPublisher(.modifyProduct(id: id, product: product))
      .flatMap { _ in
        ApiManager.shared.requestPublisher(.getMyProductList())
      }
      .eraseToAnyPublisher()
  }
}
