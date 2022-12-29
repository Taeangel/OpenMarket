//
//  FavoriteProductViewModel.swift
//  OpenMarket
//
//  Created by song on 2022/12/29.
//

import Foundation
import Combine

class FavoriteProductViewModel: ObservableObject {
  
  @Published var productList: [Product]?
  @Published var searchText: String = ""
  var productListService: AllProductListService?
  private var cancellalbes = Set<AnyCancellable>()
  
  let favoriteCoinDataService: FavoriteCoinDataService

  init(productListService: AllProductListService, favoriteCoinDataService: FavoriteCoinDataService) {
    self.productListService = productListService
    self.favoriteCoinDataService = favoriteCoinDataService
    self.addSubscribers()

  }
  
  private func addSubscribers() {
    productListService?.productListPublisher
      .receive(on: DispatchQueue.main)
      .sink { [weak self] returnedProductList in
        guard let self = self else { return }
        self.productList = returnedProductList
      }
      .store(in: &cancellalbes)
  }
}
