//
//  ProductListService.swift
//  OpenMarket
//
//  Created by song on 2022/12/23.
//

import Foundation
import Combine

class ProductListService {
  
  @Published var productList: ProductListModel?
  
  var productListValue: Published<ProductListModel?> {
    return _productList
  }
  
  var productListPublisher: Published<ProductListModel?>.Publisher {
    return $productList
  }
  
  private var coinSubscription = Set<AnyCancellable>()
  
  init() {
    getProductList()
  }
  
  func getProductList() {
    
    Provider.shared.requestPublisher(.getProductList())
      .sink(receiveCompletion: Provider.shared.handleCompletion) { [weak self] returnedProductList in
        self?.productList = returnedProductList
      }
      .store(in: &coinSubscription)
  }
}
