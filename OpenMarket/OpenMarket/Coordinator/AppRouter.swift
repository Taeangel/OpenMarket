//
//  AppRouter.swift
//  OpenMarket
//
//  Created by song on 2022/12/23.
//

import SwiftUI

enum openMarketRouter: NavigationRouter {
  case main
  
  var transition: NavigationTranisitionStyle {
    switch self {
    case .main:
      return .push
    }
  }
  
  @ViewBuilder
  func view() -> some View {
    switch self {
    case .main:
      MainView()
    }
  }
}
