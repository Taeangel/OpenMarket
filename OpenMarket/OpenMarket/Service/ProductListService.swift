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
  
  private var coinSubscription = Set<AnyCancellable>()
  
  init() {
    getProductList()
  }
  
  func getProductList() {
    
    Provider.shared.requestPublisher(.getProductList())
      .sink(receiveCompletion: Provider.shared.handleCompletion) { [weak self] returnedProductList in
        self?.productList = returnedProductList
        print(self?.productList)
      }
      .store(in: &coinSubscription)
  }
}
