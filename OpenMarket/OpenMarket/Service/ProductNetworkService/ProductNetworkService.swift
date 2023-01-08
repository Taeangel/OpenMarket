//
//  ProductListService.swift
//  OpenMarket
//
//  Created by song on 2022/12/23.
//

import Foundation
import Combine
import SwiftUI

final class ProductNetworkService: ProductListGetProtocol, ProductPostProtocol, ProductEditProtocol {
  @Published var productList: [Product] = []
  var productListPublisher: Published<[Product]>.Publisher { return $productList }
  
  @Published var myProductList: [Product] = []
  var myProductListPublisher: Published<[Product]>.Publisher { return $myProductList }
  var cancellable = Set<AnyCancellable>()
  var pageNumber = 2
  
  init() {
    initMethod()
  }
  
  private func initMethod() {
    openMarketNetwork.requestPublisher(.getProductList())
      .sink(receiveCompletion: openMarketNetwork.handleCompletion) { [weak self] returnedProductList in
        let productListModel = try? JSONDecoder().decode(ProductListModel.self, from: returnedProductList)
        self?.productList = productListModel?.product ?? []
      }
      .store(in: &cancellable)
    
    openMarketNetwork.requestPublisher(.getMyProductList())
      .sink(receiveCompletion: openMarketNetwork.handleCompletion) { [weak self] returnedProductList in
        let productListModel = try? JSONDecoder().decode(ProductListModel.self, from: returnedProductList)
        self?.myProductList = productListModel?.product ?? []
      }
      .store(in: &cancellable)
  }
}
