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
  
  let openMarketNetwork = ApiManager(session: URLSession.shared)
  
  init() {
    initMethod()
  }
  
  private func initMethod() {
    openMarketNetwork.requestPublisher(.getProductList())
      .sink(receiveCompletion: openMarketNetwork.handleCompletion) { [weak self] returnedProductList in
        let productListModel = try? JSONDecoder().decode(ProductListModel.self, from: returnedProductList)
        self?.productList = productListModel?.pages ?? []
      }
      .store(in: &cancellable)
    
    openMarketNetwork.requestPublisher(.getProductList())
      .sink(receiveCompletion: openMarketNetwork.handleCompletion) { [weak self] returnedProductList in
        let productListModel = try? JSONDecoder().decode(ProductListModel.self, from: returnedProductList)
        self?.myProductList = productListModel?.pages ?? []
      }
      .store(in: &cancellable)
  }
  
  func getProduct() {
    openMarketNetwork.requestPublisher(.getProductList(page_no: pageNumber))
      .sink(receiveCompletion: openMarketNetwork.handleCompletion) { [weak self] returnedProductList in
        let productListModel = try? JSONDecoder().decode(ProductListModel.self, from: returnedProductList)
        self?.productList += productListModel?.pages ?? []
      }
      .store(in: &cancellable)
    pageNumber += 1
  }
  
  func postProduct(parms: ProductEncodeModel, images: [Data]) -> AnyPublisher<Data, NetworkError> {
    pageNumber = 2
    
    return openMarketNetwork.requestPublisher(.postProduct(params: parms, images: images))
      .flatMap { [weak self] _ in
        (self?.openMarketNetwork.requestPublisher(.getMyProductList()))!
      }
      .eraseToAnyPublisher()
  }
  
  func deleteProduct(endPoint: String) -> AnyPublisher<Data, NetworkError> {
    pageNumber = 2
    
    return openMarketNetwork.requestPublisher(.deleteProduct(endpoint: endPoint))
      .flatMap { [weak self] _ in
        (self?.openMarketNetwork.requestPublisher(.getMyProductList()))!
      }
      .eraseToAnyPublisher()
  }
  
  func modifyProduct(id: Int, product: ProductEncodeModel) -> AnyPublisher<Data, NetworkError> {
    pageNumber = 2
    
    return openMarketNetwork.requestPublisher(.modifyProduct(id: id, product: product))
      .flatMap { [weak self] _ in
        (self?.openMarketNetwork.requestPublisher(.getMyProductList()))!
      }
      .eraseToAnyPublisher()
  }
}
