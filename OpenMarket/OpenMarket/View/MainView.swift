//
//  ContentView.swift
//  OpenMarket
//
//  Created by song on 2022/12/23.
//

import SwiftUI

struct MainView: View {
  @StateObject var vm: MainViewModel = MainViewModel()
  let productListService = ProductNetworkService()
  let favoriteProductService = FavoriteProductDataService()
  
  init() {
    UITabBar.appearance().isHidden = true
  }
  
  var body: some View {
    TabView(selection: $vm.currentTab) {
      Home(productListService: productListService, favoriteProductService: favoriteProductService)
        .tag(Tab.home)
        .setUpTab()
        .ignoresSafeArea(.keyboard, edges: .bottom)
      
      
      AddProductView(productListService: productListService)
        .tag(Tab.productRegister)
        .setUpTab()
        .ignoresSafeArea(.keyboard, edges: .bottom)
      
      
      MyProductView(productListService: productListService)
        .tag(Tab.myProductList)
        .setUpTab()
        .ignoresSafeArea(.keyboard, edges: .bottom)
      
    }
    .overlay(alignment: .bottom) {
      CustomTabBar(currentTab: $vm.currentTab)
    }
    .onAppear(perform: UIApplication.shared.hideKeyboard)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
  }
}

extension View {
  @ViewBuilder
  func setUpTab() -> some View {
    self.frame(maxWidth: .infinity, maxHeight: .infinity)
      .background {
        Color.theme.background
          .ignoresSafeArea()
      }
  }
}
