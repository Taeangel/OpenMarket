//
//  ProductService.swift
//  OpenMarket
//
//  Created by song on 2022/12/23.
//

import Foundation
import Combine

protocol ProductProtocol {
  var product: ProductModel? { get set }
  var savedEntitiesPublisher: Published<ProductModel?>.Publisher { get }
}

final class ProductService {
  
  @Published var product: ProductModel?
  
  var productPublisher: Published<ProductModel?>.Publisher {
    return $product
  }
  
  private var cancellable = Set<AnyCancellable>()
  
  init(id: Int) {
    getProduct(id)
  }
  
  private func getProduct(_ id: Int) {
    ApiManager(session: URLSession.shared).requestPublisher(.getProduct(id))
      .sink(receiveCompletion: { _ in
        
      }, receiveValue: {[weak self] returnedProduct in
        self?.product = try? JSONDecoder().decode(ProductModel.self, from: returnedProduct)
      })
      .store(in: &cancellable)
  }
}
