//
//  AppRouter.swift
//  OpenMarket
//
//  Created by song on 2022/12/23.
//

import SwiftUI

enum openMarketRouter: NavigationRouter {
  case main
  case detail(product: Page)
  case modift(product: Page)
  var transition: NavigationTranisitionStyle {
    switch self {
    case .main:
      return .push
    case .detail:
      return .push
    case .modift:
      return .presentModally
    }
  }
  
  @ViewBuilder
  func view() -> some View {
    switch self {
    case .main:
      MainView()
    case let .detail(product):
      DetailView(product: product)
    case let .modift(product):
      ModiftView(product: product)
    }
  }
}
