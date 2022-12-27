//
//  MyProductListService.swift
//  OpenMarket
//
//  Created by song on 2022/12/27.
//

import Foundation
import Combine

class MyProductListService {
  
  @Published var myProductList: ProductListModel?
  
  var myProductListValue: Published<ProductListModel?> {
    return _myProductList
  }
  
  var myProductListPublisher: Published<ProductListModel?>.Publisher {
    return $myProductList
  }
  
  private var cancellable = Set<AnyCancellable>()
  
  init() {
    getMyProductList()
  }
  
  func getMyProductList() {
    Provider.shared.requestPublisher(.getMyProductList())
      .sink(receiveCompletion: Provider.shared.handleCompletion) { [weak self] returnedProductList in
        self?.myProductList = try! JSONDecoder().decode(ProductListModel.self, from: returnedProductList)
      }
      .store(in: &cancellable)
  }
  
}
