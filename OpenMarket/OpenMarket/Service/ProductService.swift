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
  
  var productValue: Published<ProductModel?> {
    return _product
  }
  
  var productPublisher: Published<ProductModel?>.Publisher {
    return $product
  }
  
  private var coinSubscription = Set<AnyCancellable>()
  
  init(id: Int) {
    getProduct(id)
  }
  
  func getProduct(_ id: Int) {
    Provider.shared.requestPublisher(.getProduct(id))
      .sink(receiveCompletion: Provider.shared.handleCompletion) { [weak self] returnedProduct in
        self?.product = try! JSONDecoder().decode(ProductModel.self, from: returnedProduct)
      }
      .store(in: &coinSubscription)
  }
}
