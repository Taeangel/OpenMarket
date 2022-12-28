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
  case modify(product: Page, myProductListService: AllProductListService)
  var transition: NavigationTranisitionStyle {
    switch self {
    case .main:
      return .push
    case .detail:
      return .push
    case .modify:
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
    case let .modify(product, myProductListService):
      ModiftView(product: product, myProductListService: myProductListService)
    }
  }
}
