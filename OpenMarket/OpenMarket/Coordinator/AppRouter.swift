//
//  AppRouter.swift
//  OpenMarket
//
//  Created by song on 2022/12/23.
//

import SwiftUI

enum coinAppRouter: NavigationRouter {
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
      ContentView()
    }
  }
}
