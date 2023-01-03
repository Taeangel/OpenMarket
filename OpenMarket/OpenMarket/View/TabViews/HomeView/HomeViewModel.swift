//
//  HomeViewModel.swift
//  OpenMarket
//
//  Created by song on 2022/12/25.
//

import Foundation
import Combine
import SwiftUI

final class HomeViewModel: ObservableObject {
  @Published var productList: [Product]?
  @Published var searchText: String = ""
  @Published var searchedProductList: [Product]?
  
  let productListService: ProductListGetProtocol?
  private var cancellalbes = Set<AnyCancellable>()

  init(productListService: ProductListGetProtocol) {
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
  
  func searchProductList() {
    productListService?.getSearchProductList(searchValue: searchText)
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { completion in
      }, receiveValue: { [weak self] returnedProductList in
        guard let self = self else { return }
        let productListModel = try? JSONDecoder().decode(ProductListModel.self, from: returnedProductList)
        self.searchedProductList = productListModel?.product ?? []
      })
      .store(in: &cancellalbes)
  }
}
