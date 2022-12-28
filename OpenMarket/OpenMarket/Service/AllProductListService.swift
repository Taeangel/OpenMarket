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
  
  @Published var productList: ProductListModel?
  var productListPublisher: Published<ProductListModel?>.Publisher { return $productList }
  
  @Published var myProductList: ProductListModel?
  var myProductListPublisher: Published<ProductListModel?>.Publisher { return $myProductList }
  
  private var cancellable = Set<AnyCancellable>()
  
  init() {
    addSubscriber()
  }
  
  func addSubscriber() {
    Provider.shared.requestPublisher(.getProductList())
      .sink(receiveCompletion: Provider.shared.handleCompletion) { [weak self] returnedProductList in
        self?.productList = try? JSONDecoder().decode(ProductListModel.self, from: returnedProductList)
      }
      .store(in: &cancellable)
    
    Provider.shared.requestPublisher(.getMyProductList())
      .sink(receiveCompletion: Provider.shared.handleCompletion) { [weak self] returnedProductList in
        self?.myProductList = try? JSONDecoder().decode(ProductListModel.self, from: returnedProductList)
      }
      .store(in: &cancellable)
  }
  
  func postProduct(parms: Product, images: [Data]) -> AnyPublisher<Data, NetworkError> {
    Provider.shared.requestPublisher(.postProduct(params: parms, images: images))
      .flatMap { _ in
        Provider.shared.requestPublisher(.getMyProductList())
      }
      .eraseToAnyPublisher()
  }
  
  func deleteProduct(endPoint: String) -> AnyPublisher<Data, NetworkError> {
    Provider.shared.requestPublisher(.deleteProduct(endpoint: endPoint))
      .flatMap { _ in
        Provider.shared.requestPublisher(.getMyProductList())
      }
      .eraseToAnyPublisher()
  }
  
  func modifyProduct(id: Int, product: Product) -> AnyPublisher<Data, NetworkError> {
    Provider.shared.requestPublisher(.modifyProduct(id: id, product: product))
      .flatMap { _ in
        Provider.shared.requestPublisher(.getMyProductList())
      }
      .eraseToAnyPublisher()
  }
  
  private func mergeProductLists() -> AnyPublisher<Data, NetworkError> {
    Publishers.Merge(Provider.shared.requestPublisher(.getMyProductList()),
                     Provider.shared.requestPublisher(.getProductList()))
      .eraseToAnyPublisher()
  }
}
