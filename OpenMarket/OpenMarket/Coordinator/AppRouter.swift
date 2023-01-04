//
//  AppRouter.swift
//  OpenMarket
//
//  Created by song on 2022/12/23.
//

import SwiftUI

enum openMarketRouter: NavigationRouter {
  var viewFactory: ViewFactory {
    return ViewFactory(container: DIContainer(favoriteProductDataService: FavoriteProductDataService(), productNetworkService: ProductNetworkService()))
  }
  
  case main
  case detail(product: Product)
  case modify(product: Product)
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
        .environmentObject(viewFactory)
    case let .detail(product):
      viewFactory.makeDetailView(id: product.id ?? 0)
    case let .modify(product):
      viewFactory.makeModifyView(id: product.id ?? 0)
    }
  }
}
