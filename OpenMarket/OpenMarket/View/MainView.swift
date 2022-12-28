//
//  ContentView.swift
//  OpenMarket
//
//  Created by song on 2022/12/23.
//

import SwiftUI

struct MainView: View {
  @StateObject var vm: MainViewModel = MainViewModel()
  let productListService = AllProductListService()
  
  
  init() {
    UITabBar.appearance().isHidden = true
  }
  
  var body: some View {
    TabView(selection: $vm.currentTab) {
      Home(productListService: productListService)
        .tag(Tab.home)
        .setUpTab()
      
      AddProductView(productListService: productListService)
        .tag(Tab.productRegister)
        .setUpTab()
      
      Text("Favorite")
        .tag(Tab.favorite)
        .setUpTab()
      
      MyProductView(allPorductListService: productListService)
        .tag(Tab.myProductList)
        .setUpTab()
      
    }
    .overlay(alignment: .bottom) {
      CustomTabBar(currentTab: $vm.currentTab)
    }
    .onAppear(perform:  UIApplication.shared.hideKeyboard)
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
