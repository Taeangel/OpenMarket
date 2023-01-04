//
//  DetailViewModel.swift
//  OpenMarket
//
//  Created by song on 2022/12/24.
//

import Foundation
import Combine

final class DetailViewModel: ObservableObject {
  @Published var product: ProductModel?
  @Published var showDetailView: Bool = false
  @Published var cartCount: Int = 0
  @Published var totolPrice: Int = 0
  @Published var favoriteProduct: Bool = false
  private let favoriteProductService: FavoriteProductDataProtocol
  private  let productService: ProductService
  private var cancellalbes = Set<AnyCancellable>()
  
  init(id: Int, favoriteProductService: FavoriteProductDataProtocol) {
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
      .debounce(for: 0.1, scheduler: RunLoop.main)
      .receive(on: RunLoop.main)
      .map { [weak self] in $0.filter { $0.productId == self?.product?.id ?? 0 } }
      .sink(receiveValue: { [unowned self] isFavorites in
        if isFavorites.isEmpty {
          self.favoriteProduct = false
        } else {
          self.favoriteProduct = true
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


