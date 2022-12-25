//
//  CustomTabBar.swift
//  OpenMarket
//
//  Created by song on 2022/12/23.
//

import SwiftUI
 
struct CustomTabBar: View {
  
  @Binding var currentTab: Tab
  @State var currentXValue: CGFloat = 0
  @Namespace var animation

  var body: some View {
    HStack(spacing: 0, content: {
      ForEach(Tab.allCases, id: \.rawValue) { tab in
        TabButton(tab: tab)
         
      }
    })
    .padding(.top)
    .padding(.bottom, getSafeArea().bottom == 0 ? 15 : 10 )
    .background {
      Color.theme.tabBarBackground
        .shadow(color: Color.theme.background ,radius: 5, x: 0, y: -5)
        .clipShape(BottomCurve(currentXvalue: currentXValue))
        .ignoresSafeArea(.container, edges: .bottom)
    }
  }
}

extension CustomTabBar {
  
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
          .renderingMode(.template)
          .aspectRatio(contentMode: .fit)
          .frame(width: 25, height: 25)
          .frame(maxWidth: .infinity)
          .foregroundColor(currentTab == tab ? Color.theme.white : Color.theme.secondaryText)
          .padding(currentTab == tab ? 15 : 0)
          .background(
          
            ZStack {
              if currentTab == tab {
                
                Circle()
                  .fill(Color.theme.red)
                  .shadow(color: Color.theme.background ,radius: 8, x: 5, y: 5)
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

enum Tab: String, CaseIterable {
  case home = "house.fill"
  case cart = "cart.fill"
  case favorite = "star.fill"
  case profile = "person.fill"
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
