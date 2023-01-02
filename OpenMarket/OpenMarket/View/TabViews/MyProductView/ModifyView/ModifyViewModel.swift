//
//  ModifyViewModel.swift
//  OpenMarket
//
//  Created by song on 2022/12/27.
//

import Foundation
import SwiftUI
import Combine

final class ModiftViewModel: ProductValidationViewModel {
  @Published var showDetailView: Bool = false
  @Published var showAlert: Bool = false
  @Published var isPostSuccess: Bool = false
  @Published var alertMessage: String = ""
  var imageURL: [ProductImage] = []
  let productService: ProductService
  var productId: Int
  let allProductListService: ProductNetworkService
  private var cancellalbes = Set<AnyCancellable>()
  
  init(id: Int, myProductListService: ProductNetworkService) {
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
      .sink{ [weak self] completion in
        guard let self = self else { return }
        switch completion {
        case .finished:
          self.showAlert = true
          self.isPostSuccess = true
          self.alertMessage = "Delete에 성공했습니다!"
        case let .failure(error):
          self.showAlert = true
          self.isPostSuccess = false
          self.alertMessage = "\(error)가 있습니다ㅜ"
        }
      }receiveValue: { [weak self] returnedProductList in
        guard let self = self else { return }
        let productListModel = try? JSONDecoder().decode(ProductListModel.self, from: returnedProductList)
        self.allProductListService.myProductList = productListModel?.pages ?? []
        self.listUpdata()
      }
      .store(in: &self.cancellalbes)
  }
  
  private func listUpdata() {
    ApiManager.shared.requestPublisher(.getProductList())
      .sink(receiveCompletion: ApiManager.shared.handleCompletion) { [weak self] returnedProductList in
        let productListModel = try? JSONDecoder().decode(ProductListModel.self, from: returnedProductList)
        self?.allProductListService.productList = productListModel?.pages ?? []
      }
      .store(in: &cancellable)
  }
  
  deinit {
    cancellalbes.removeAll()
  }
}
