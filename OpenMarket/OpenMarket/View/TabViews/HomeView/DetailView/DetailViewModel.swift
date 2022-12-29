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
  @Published var favoriteProduct: Bool = true
  let favoriteProductService: FavoriteProductDataService
  let productService: ProductService
  private var cancellalbes = Set<AnyCancellable>()
  
  
  
  init(id: Int, favoriteProductService: FavoriteProductDataService) {
    self.favoriteProductService = favoriteProductService
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
      .map{ [weak self] in $0 * (self?.product?.discountedPrice ?? 0) }
      .sink { [weak self] totolPrice in
        self?.totolPrice = totolPrice
      }
      .store(in: &cancellalbes)

    favoriteProductService.savedEntitiesPublisher
      .map {[weak self] in $0.filter { $0.productId == self?.product?.id ?? 0  } }
      .map { $0.first }
      .sink(receiveValue: { [unowned self]  isFavorite in
        if let isFavorite {
          self.favoriteProduct = true
        } else {
          self.favoriteProduct = false
        }
      })
      .store(in: &cancellalbes)
  }
  
  func tapHeart() {
    favoriteProductService.updateFavoriteProduct(id: product?.id ?? 0)
  }
  
  deinit {
    cancellalbes.removeAll()
  }
}


