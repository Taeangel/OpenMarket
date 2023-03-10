//
//  ModifyViewModel.swift
//  OpenMarket
//
//  Created by song on 2022/12/27.
//

import Foundation
import SwiftUI
import Combine

final class ModifyViewModel: ProductValidationViewModel {
  @Published var showDetailView: Bool = false
  @Published var showAlert: Bool = false
  @Published var isPostSuccess: Bool = false
  @Published var alertMessage: String = ""
  var imageURL: [ProductImage] = []
  private let productService: ProductService
  private var productId: Int
  private var productListService: ProductEditProtocol
  private let openMarketNetwork = ApiManager(session: URLSession.shared)

  init(id: Int, myProductListService: ProductEditProtocol) {
    self.productListService = myProductListService
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
      .store(in: &cancellable)
  }
   
  func modifyProduct() {
    productListService.modifyProduct(id: productId, product: makeProduct())
      .receive(on: DispatchQueue.main)
      .sink{ [weak self] completion in
        guard let self = self else { return }
        switch completion {
        case .finished:
          self.showAlert = true
          self.isPostSuccess = true
          self.alertMessage = "수정에 성공했습니다!"
        case let .failure(error):
          self.showAlert = true
          self.isPostSuccess = false
          self.alertMessage = "\(error)가 있습니다ㅜ"
        }
      }receiveValue: { [weak self] returnedProductList in
        guard let self = self else { return }
        let productListModel = try? JSONDecoder().decode(ProductListModel.self, from: returnedProductList)
        self.productListService.myProductList = productListModel?.product ?? []
        self.listUpdata()
      }
      .store(in: &cancellable)
  }
  
  private func listUpdata() {
    openMarketNetwork.requestPublisher(.getProductList())
      .sink(receiveCompletion: openMarketNetwork.handleCompletion) { [weak self] returnedProductList in
        let productListModel = try? JSONDecoder().decode(ProductListModel.self, from: returnedProductList)
        self?.productListService.productList = productListModel?.product ?? []
      }
      .store(in: &cancellable)
  }
  
  deinit {
    cancellable.removeAll()
  }
}
