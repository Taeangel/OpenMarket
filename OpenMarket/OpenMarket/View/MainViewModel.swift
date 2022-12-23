//
//  MainViewModel.swift
//  OpenMarket
//
//  Created by song on 2022/12/23.
//

import Foundation
import Combine

class MainViewModel: ObservableObject {
  @Published var currentTab: Tab = .home
  @Published var currentMenu: String = "All"
  @Published var productList: ProductListModel?
  
  let productListService = ProductListService()
  
  private var cancellalbes = Set<AnyCancellable>()

  init() {
    self.addSubscribers()
  }
  
  private func addSubscribers() {
    productListService.productListPublisher
      .receive(on: DispatchQueue.main)
      .sink { [weak self] returnedProductList in
        guard let self = self else { return }
        guard let returnedProductList = returnedProductList else { return }
        self.productList = returnedProductList
      }
      .store(in: &cancellalbes)
  }
}
 
