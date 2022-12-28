//
//  MyProductViewModel.swift
//  OpenMarket
//
//  Created by song on 2022/12/27.
//

import Foundation
import Combine

class MyProductViewModel: ObservableObject {
  @Published var productList: ProductListModel?
  @Published var searchText: String = ""
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
        guard let returnedProductList = returnedProductList else { return }
        self.productList = returnedProductList
      }
      .store(in: &cancellable)
  }
  
  func deleteProduct(_ id: Int) {
    Provider.shared.requestPublisher(.productDeletionURISearch(id: id))
      .sink { completion in
        print(completion)
      } receiveValue: { data in
        guard let deleteURL = String(data: data, encoding: .utf8) else { return }
        self.allProductListService.deleteProduct(endPoint: deleteURL)
          .sink { completion in
            print(completion)
          } receiveValue: { [weak self] returnedProductList in
            guard let self = self else { return }
            self.allProductListService.myProductList = try? JSONDecoder().decode(ProductListModel.self, from: returnedProductList)
            self.listUpdata()
          }
          .store(in: &self.cancellable)
      }
      .store(in: &cancellable)
  }
  
  private func listUpdata() {
    Provider.shared.requestPublisher(.getProductList())
      .sink(receiveCompletion: Provider.shared.handleCompletion) { [weak self] returnedProductList in
        self?.allProductListService.productList = try? JSONDecoder().decode(ProductListModel.self, from: returnedProductList)
      }
      .store(in: &cancellable)
  }
}
