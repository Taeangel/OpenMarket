//
//  HomeViewModel.swift
//  OpenMarket
//
//  Created by song on 2022/12/25.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
  @Published var productList: [Product]?
  @Published var searchText: String = ""
  
  weak var productListService: ProductNetworkService?
  private var cancellalbes = Set<AnyCancellable>()

  init(productListService: ProductNetworkService) {
    self.productListService = productListService
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
