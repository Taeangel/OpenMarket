//
//  CustomTabBar.swift
//  OpenMarket
//
//  Created by song on 2022/12/23.
//

import SwiftUI
 
struct CustomTabBarView: View {
  
  @State var currentTab: Tab = .Home
  
  @Namespace var animation
  
  @State var currentXValue: CGFloat = 0
  
  init() {
    UITabBar.appearance().isHidden = true
  }
  
  var body: some View {
    TabView(selection: $currentTab) {
      Text("Home")
        .background(Color("BG").ignoresSafeArea())
        .tag(Tab.Home)
      
      Text("Search")
        .background(Color("BG").ignoresSafeArea())
        .tag(Tab.Search)
      
      Text("Notifications")
        .background(Color("BG").ignoresSafeArea())
        .tag(Tab.Notifications)
      
      Text("Account")
        .background(Color("BG").ignoresSafeArea())
        .tag(Tab.Account)
    }
    .overlay(
      HStack(spacing: 0) {
        
        ForEach(Tab.allCases, id: \.rawValue) { tab in
          TabButton(tab: tab)
        }
      }
        .padding(.vertical)
        .padding(.bottom, getSafeArea().bottom == 0 ? 10 : (getSafeArea().bottom - 10) )
        .background(
        
          MaterialEffect(style: .systemMaterialDark)
            .clipShape(BottomCurve(currentXvalue: currentXValue))
        )
      , alignment: .bottom
    )
    .ignoresSafeArea(.all, edges: .bottom)
    .preferredColorScheme(.dark)
  }
}

extension CustomTabBarView {

  @ViewBuilder
  func TabButton(tab: Tab) -> some View {
    
    GeometryReader { proxy in
      Button {
        withAnimation(.spring()) {
          currentTab = tab
          currentXValue = proxy.frame(in: .global).midX
        }
      } label: {
        Image(systemName: tab.rawValue)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 25, height: 25)
          .frame(maxWidth: .infinity)
          .padding(currentTab == tab ? 15 : 0)
          .background(
          
            ZStack {
              if currentTab == tab {
                MaterialEffect(style:
                    .systemMaterialDark)
                .clipShape(Circle())
                .matchedGeometryEffect(id: "TAB", in: animation)
              }
            }
          )
          .contentShape(Rectangle())
          .offset(y: currentTab == tab ? -50 : 0)
          
    }
      .onAppear {
        if tab == Tab.allCases.first {
          currentXValue = proxy.frame(in: .global).midX
        }
      }
    }
    .frame(height: 30)
  }
}

struct CustomTabBar_Previews: PreviewProvider {
  static var previews: some View {
    CustomTabBarView()
  }
}

enum Tab: String, CaseIterable {
  case Home = "house.fill"
  case Search = "magnifyingglass"
  case Notifications = "bell.fill"
  case Account = "person.fill"
}

extension View {
  func getSafeArea() -> UIEdgeInsets {
    guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
      return .zero
    }
    
    guard let safeArea = screen.windows.first?.safeAreaInsets else {
      return .zero
    }
    
    return safeArea
  }
}
