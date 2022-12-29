//
//  ProductListService.swift
//  OpenMarket
//
//  Created by song on 2022/12/23.
//

import Foundation
import Combine
import SwiftUI

class AllProductListService {
  
  @Published var productList: [Product]?
  var productListPublisher: Published<[Product]?>.Publisher { return $productList }
  
  @Published var myProductList: [Product]?
  var myProductListPublisher: Published<[Product]?>.Publisher { return $myProductList }
  
  private var cancellable = Set<AnyCancellable>()
  
  init() {
    addSubscriber()
  }
  
  private func addSubscriber() {
    ApiManager.shared.requestPublisher(.getProductList())
      .sink(receiveCompletion: ApiManager.shared.handleCompletion) { [weak self] returnedProductList in
        let productListModel = try? JSONDecoder().decode(ProductListModel.self, from: returnedProductList)
        self?.productList = productListModel?.pages
      }
      .store(in: &cancellable)
    
    ApiManager.shared.requestPublisher(.getMyProductList())
      .sink(receiveCompletion: ApiManager.shared.handleCompletion) { [weak self] returnedProductList in
        let productListModel = try? JSONDecoder().decode(ProductListModel.self, from: returnedProductList)
        self?.myProductList = productListModel?.pages
      }
      .store(in: &cancellable)
  }
  
  func getProduct(pageNumber: Int) {
    ApiManager.shared.requestPublisher(.getProductList(page_no: pageNumber))
      .sink(receiveCompletion: ApiManager.shared.handleCompletion) { [weak self] returnedProductList in
        let productListModel = try? JSONDecoder().decode(ProductListModel.self, from: returnedProductList)
        self?.productList = productListModel?.pages
      }
      .store(in: &cancellable)
  }
  
  func postProduct(parms: ProductEncodeModel, images: [Data]) -> AnyPublisher<Data, NetworkError> {
    ApiManager.shared.requestPublisher(.postProduct(params: parms, images: images))
      .flatMap { _ in
        ApiManager.shared.requestPublisher(.getMyProductList())
      }
      .eraseToAnyPublisher()
  }
  
  func deleteProduct(endPoint: String) -> AnyPublisher<Data, NetworkError> {
    ApiManager.shared.requestPublisher(.deleteProduct(endpoint: endPoint))
      .flatMap { _ in
        ApiManager.shared.requestPublisher(.getMyProductList())
      }
      .eraseToAnyPublisher()
  }
  
  func modifyProduct(id: Int, product: ProductEncodeModel) -> AnyPublisher<Data, NetworkError> {
    ApiManager.shared.requestPublisher(.modifyProduct(id: id, product: product))
      .flatMap { _ in
        ApiManager.shared.requestPublisher(.getMyProductList())
      }
      .eraseToAnyPublisher()
  }
  
  private func mergeProductLists() -> AnyPublisher<Data, NetworkError> {
    Publishers.Merge(ApiManager.shared.requestPublisher(.getMyProductList()),
                     ApiManager.shared.requestPublisher(.getProductList()))
    .eraseToAnyPublisher()
  }
}
