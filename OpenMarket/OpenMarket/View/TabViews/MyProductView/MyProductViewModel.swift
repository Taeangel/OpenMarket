//
//  MyProductViewModel.swift
//  OpenMarket
//
//  Created by song on 2022/12/27.
//

import Foundation
import Combine

final class MyProductViewModel: ObservableObject {
  @Published var productList: [Product]?
  @Published var searchText: String = ""
  @Published var showAlert: Bool = false
  @Published var isPostSuccess: Bool = false
  @Published var alertMessage: String = ""
  
  let allProductListService: AllProductListService
  private var cancellable = Set<AnyCancellable>()

  init(allProductListService: AllProductListService) {
    self.allProductListService = allProductListService
    self.addSubscribers()
  }
  
  private func addSubscribers() {
    allProductListService.myProductListPublisher
      .receive(on: DispatchQueue.main)
      .sink { [weak self] returnedProductList in
        guard let self = self else { return }
        self.productList = returnedProductList
      }
      .store(in: &cancellable)
  }
  
  func deleteProduct(_ id: Int) {
    ApiManager.shared.requestPublisher(.productDeletionURISearch(id: id))
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
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
      } receiveValue: { [weak self] data in
        guard let self = self else { return }
        guard let deleteURL = String(data: data, encoding: .utf8) else { return }
        self.allProductListService.deleteProduct(endPoint: deleteURL)
          .sink { completion in
            print(completion)
          } receiveValue: { [weak self] returnedProductList in
            guard let self = self else { return }
            let productListModel = try? JSONDecoder().decode(ProductListModel.self, from: returnedProductList)
            self.allProductListService.myProductList = productListModel?.pages ?? []
            self.listUpdata()
          }
          .store(in: &self.cancellable)
      }
      .store(in: &cancellable)
  }
  
  private func listUpdata() {
    ApiManager.shared.requestPublisher(.getProductList())
      .sink(receiveCompletion: ApiManager.shared.handleCompletion) { [weak self] returnedProductList in
        let productListModel = try? JSONDecoder().decode(ProductListModel.self, from: returnedProductList)
        self?.allProductListService.productList = productListModel?.pages ?? []
      }
      .store(in: &cancellable)
  }
}
