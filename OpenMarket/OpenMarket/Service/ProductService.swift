//
//  ProductService.swift
//  OpenMarket
//
//  Created by song on 2022/12/23.
//

import Foundation
import Combine

class ProductService {
  
  @Published var product: ProductModel?
  
  private var coinSubscription = Set<AnyCancellable>()
  
  let id: Int
  init(id: Int) {
    self.id = id
    getProduct()
  }
  
  func getProduct() {
    Provider.shared.requestPublisher(.getProduct(id))
      .sink(receiveCompletion: Provider.shared.handleCompletion) { [weak self] returnedProduct in
        self?.product = returnedProduct
      }
      .store(in: &coinSubscription)
  }
}
