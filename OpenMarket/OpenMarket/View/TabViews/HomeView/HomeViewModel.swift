//
//  HomeViewModel.swift
//  OpenMarket
//
//  Created by song on 2022/12/25.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
  @Published var productList: ProductListModel?
  @Published var searchText: String = ""
  weak var productListService: AllProductListService?
  private var cancellalbes = Set<AnyCancellable>()

  init(productListService: AllProductListService) {
    self.productListService = productListService
    self.addSubscribers()

  }
  private func addSubscribers() {
    productListService?.productListPublisher
      .receive(on: DispatchQueue.main)
      .sink { [weak self] returnedProductList in
        guard let self = self else { return }
        guard let returnedProductList = returnedProductList else { return }
        self.productList = returnedProductList
      }
      .store(in: &cancellalbes)
  }
}
