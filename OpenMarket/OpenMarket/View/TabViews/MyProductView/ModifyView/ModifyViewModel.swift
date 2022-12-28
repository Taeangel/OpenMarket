//
//  ModifyViewModel.swift
//  OpenMarket
//
//  Created by song on 2022/12/27.
//

import Foundation
import SwiftUI
import Combine

class ModiftViewModel: ProductValidationViewModel {
  @Published var showDetailView: Bool = false
  var imageURL: [ProductImage] = []
  let productService: ProductService
  var productId: Int
  let allProductListService: AllProductListService
  
  private var cancellalbes = Set<AnyCancellable>()
  
  init(id: Int, myProductListService: AllProductListService) {
    self.allProductListService = myProductListService
    self.productId = id
    self.productService = ProductService(id: id)
    super.init()
    self.addSubscribers(id)
    self.addSubscriber()
  }
  
  private func addSubscribers(_ id: Int) {
    productService.productPublisher
      .receive(on: DispatchQueue.main)
      .sink { [weak self] returnedProduct in
        guard let self = self else { return }
        guard let returnedProduct = returnedProduct else { return }
        self.productName = returnedProduct.name ?? ""
        self.price = String(returnedProduct.price ?? 0)
        self.discountPrice = String(returnedProduct.discountedPrice ?? 0)
        self.stock = String(returnedProduct.stock ?? 0)
        self.productDescription = returnedProduct.productDescription ?? ""
        self.imageURL = returnedProduct.images
        self.images.append(UIImage())
      }
      .store(in: &cancellalbes)
  }
   
  func modifyProduct() {
    allProductListService.modifyProduct(id: productId, product: makeProduct())
      .sink { completion in
        print(completion)
      } receiveValue: { [weak self] returnedProductList in
        guard let self = self else { return }
        self.allProductListService.myProductList = try? JSONDecoder().decode(ProductListModel.self, from: returnedProductList)
        self.listUpdata()
      }
      .store(in: &self.cancellalbes)
  }
  
  private func listUpdata() {
    Provider.shared.requestPublisher(.getProductList())
      .sink(receiveCompletion: Provider.shared.handleCompletion) { [weak self] returnedProductList in
        self?.allProductListService.productList = try? JSONDecoder().decode(ProductListModel.self, from: returnedProductList)
      }
      .store(in: &cancellable)
  }
}
