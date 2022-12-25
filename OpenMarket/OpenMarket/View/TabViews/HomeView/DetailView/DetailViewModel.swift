//
//  DetailViewModel.swift
//  OpenMarket
//
//  Created by song on 2022/12/24.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
  @Published var product: ProductModel?
  @Published var showDetailView: Bool = false
  @Published var cartCount: Int = 0
  @Published var totolPrice: Int = 0
  
  let productService: ProductService
  
  private var cancellalbes = Set<AnyCancellable>()

  init(id: Int) {
    self.productService = ProductService(id: id)
    self.addSubscribers(id)
  }
  
  private func addSubscribers(_ id: Int) {
    productService.productPublisher
      .receive(on: DispatchQueue.main)
      .sink { [weak self] returnedProduct in
        guard let self = self else { return }
        self.product = returnedProduct
      }
      .store(in: &cancellalbes)
    
    $cartCount
      .map{ [self] in $0 * (product?.discountedPrice ?? 0) }
      .sink { [weak self] totolPrice in
        guard let self = self else { return }
        self.totolPrice = totolPrice
      }
      .store(in: &cancellalbes)
  }
}

  
