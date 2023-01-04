//
//  ViewFactory.swift
//  OpenMarket
//
//  Created by song on 2023/01/04.
//

import Foundation

final class ViewFactory: ObservableObject {
  private let container : DIContainer
  
  init(container: DIContainer) {
    self.container = container
  }
  
  func makeHomeViewModel() -> HomeView {
    return HomeView(vm: HomeViewModel(productListService: self.container.productNetworkService))
  }
  
  func makeDetailView(id: Int) -> DetailView {
    return DetailView(vm: DetailViewModel(id: id, favoriteProductService: self.container.favoriteProductDataService))
  }
  
  func makeAddProductView() -> AddProductView {
    return AddProductView(vm: AddProductViewModel(productListService: self.container.productNetworkService))
  }
  
  func makeMyProductView() -> MyProductView {
    return MyProductView(vm: MyProductViewModel(allProductListService: self.container.productNetworkService))
  }
  
  
  func makeModifyView(id: Int) -> ModiftView {
    return ModiftView(vm: ModifyViewModel(id: id, myProductListService: self.container.productNetworkService))
  }
}
