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
  let myProductListService = MyProductListService()
  private var cancellalbes = Set<AnyCancellable>()

  init() {
    self.addSubscribers()

  }
  private func addSubscribers() {
    myProductListService.myProductListPublisher
      .receive(on: DispatchQueue.main)
      .sink { [weak self] returnedProductList in
        guard let self = self else { return }
        guard let returnedProductList = returnedProductList else { return }
        self.productList = returnedProductList
      }
      .store(in: &cancellalbes)
  }
  
  
  func deleteProduct(_ id: Int) {
    Provider.shared.requestPublisher(.productDeletionURISearch(id: id))
      .sink { completion in
        print(completion)
      } receiveValue: { data in
        guard let deleteURL = String(data: data, encoding: .utf8) else { return }
        print(deleteURL)
        Provider.shared.requestPublisher(.deleteProduct(endpoint: deleteURL))
          .sink { completion in
            print(completion)
          } receiveValue: { _ in
            
          }
          .store(in: &self.cancellalbes)
      }
      .store(in: &cancellalbes)


  }
  

}
