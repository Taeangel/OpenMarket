//
//  ContentView.swift
//  OpenMarket
//
//  Created by song on 2022/12/23.
//

import SwiftUI

struct MainView: View {

  @StateObject var vm: MainViewModel = .init()
  @Namespace var animation
  
  init() {
    UITabBar.appearance().isHidden = true
  }
  
  var body: some View {
    TabView(selection: $vm.currentTab) {
      Home(animation: animation)
        .environmentObject(vm)
        .tag(Tab.home)
        .setUpTab()
      
      Text("Cart")
        .tag(Tab.cart)
        .setUpTab()
      
      Text("Favorite")
        .tag(Tab.favorite)
        .setUpTab()
      
      Text("Profile")
        .tag(Tab.profile)
        .setUpTab()
      
    }
    .overlay(alignment: .bottom) {
      CustomTabBar(currentTab: $vm.currentTab, animation: animation)
        .offset(y: vm.showDetailView ? 150 : 0)
    }
    .overlay(content: {
      if let page = vm.currentActiveItem, vm.showDetailView {
        DetailView(product: page, animation: animation)
          .environmentObject(vm)
          .transition(.offset(x: 1, y: 1))
      }
    })
    .background(Color.theme.background)
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
        Color("BG")
          .ignoresSafeArea()
      }
  }
}
