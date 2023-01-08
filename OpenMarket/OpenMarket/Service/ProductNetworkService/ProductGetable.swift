//
//  ProductGetable.swift
//  OpenMarket
//
//  Created by song on 2023/01/09.
//

import Foundation
import Combine

protocol ProductGetable: OpenMarketService {
  func getProduct()
  func getSearchProductList(searchValue: String) -> AnyPublisher<Data, NetworkError>
}

extension ProductGetable {
  func getSearchProductList(searchValue: String) -> AnyPublisher<Data, NetworkError> {
    openMarketNetwork.requestPublisher(.getSearchProductList(search_value: searchValue))
      .eraseToAnyPublisher()
  }
  
  func getProduct() {
    openMarketNetwork.requestPublisher(.getProductList(page_no: pageNumber))
      .sink(receiveCompletion: openMarketNetwork.handleCompletion) { [weak self] returnedProductList in
        let productListModel = try? JSONDecoder().decode(ProductListModel.self, from: returnedProductList)
        self?.productList += productListModel?.product ?? []
      }
      .store(in: &cancellable)
    pageNumber += 1
  }
}
