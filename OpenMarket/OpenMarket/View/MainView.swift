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
    }
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
