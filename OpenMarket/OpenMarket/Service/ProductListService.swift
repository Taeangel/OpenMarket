//
//  ProductListService.swift
//  OpenMarket
//
//  Created by song on 2022/12/23.
//

import Foundation
import Combine
import SwiftUI

class ProductListService {
  
  @Published var productList: ProductListModel?
  
  var productListValue: Published<ProductListModel?> {
    return _productList
  }
  
  var productListPublisher: Published<ProductListModel?>.Publisher {
    return $productList
  }
  
  private var cancellable = Set<AnyCancellable>()
  
  init() {
    getProductList()
  }
  
  func getProductList() {
    Provider.shared.requestPublisher(.getProductList())
      .sink(receiveCompletion: Provider.shared.handleCompletion) { [weak self] returnedProductList in
        self?.productList = try! JSONDecoder().decode(ProductListModel.self, from: returnedProductList)
      }
      .store(in: &cancellable)
  }
  
  
//  func postProduct(parms: Product, images: [Data]) {
//    Provider.shared.requestPublisher(.postProduct(params: parms, images: images))
//      .sink(receiveCompletion: Provider.shared.handleCompletion) {  _ in }
//      .store(in: &cancellable)
//  }
  
  func postProduct(parms: Product, images: [Data]) -> AnyPublisher<Data, NetworkErrorError> {
    Provider.shared.requestPublisher(.postProduct(params: parms, images: images))
      .flatMap { _ in
        Provider.shared.requestPublisher(.getProductList())
      }
      .compactMap { $0 }
      .eraseToAnyPublisher()
  }
  
  
  
}
