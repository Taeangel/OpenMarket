//
//  AddProductViewModel.swift
//  OpenMarket
//
//  Created by song on 2022/12/25.
//

import Foundation
import SwiftUI
import Combine

class AddProductViewModel: ProductValidationViewModel {
  private weak var allProductListService: AllProductListService?
  
  init(productListService: AllProductListService) {
    self.allProductListService = productListService
    super.init()
    self.addSubscriber()
  }
  
  private func convertImageToData() -> [Data] {
    return images.map { $0.jpegData(compressionQuality: 0.1) ?? Data() }
  }
  
  func postProduct() {
    allProductListService?.postProduct(parms: makeProduct(), images: convertImageToData())
      .sink(receiveCompletion: ApiManager.shared.handleCompletion) { [weak self] returnedProductList in
        let productListModel = try? JSONDecoder().decode(ProductListModel.self, from: returnedProductList)
        self?.allProductListService?.myProductList = productListModel?.pages ?? []
        self?.listUpdata()
      }
      .store(in: &cancellable)
    cleanAddView()
  }
  
  private func listUpdata() {
    ApiManager.shared.requestPublisher(.getProductList())
      .sink(receiveCompletion: ApiManager.shared.handleCompletion) { [weak self] returnedProductList in
        let productListModel = try? JSONDecoder().decode(ProductListModel.self, from: returnedProductList)
        self?.allProductListService?.productList = productListModel?.pages ?? []
      }
      .store(in: &cancellable)
  }
  
  private func cleanAddView() {
    self.images = []
    self.productName = ""
    self.price = ""
    self.discountPrice = ""
    self.stock = ""
    self.productDescription = ""
    self.informationError = ""
    self.currency = .KRW
  }
}

