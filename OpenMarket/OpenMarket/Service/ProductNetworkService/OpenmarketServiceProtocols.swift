//
//  Protocols.swift
//  OpenMarket
//
//  Created by song on 2023/01/09.
//

import Foundation
import Combine

protocol OpenMarketService: AnyObject {
  var productList: [Product] { get set }
  var productListPublisher: Published<[Product]>.Publisher { get }
  var myProductList: [Product] { get set }
  var myProductListPublisher: Published<[Product]>.Publisher { get }
  var cancellable: Set<AnyCancellable> { get set }
  var pageNumber: Int { get set }
  var openMarketNetwork: ApiManager { get }
}

extension OpenMarketService {
  var openMarketNetwork: ApiManager {
    return ApiManager(session: URLSession.shared)
  }
}

protocol ProductListGetProtocol: OpenMarketService, ProductGetable {}
protocol ProductPostProtocol: OpenMarketService, ProductPostable {}
protocol ProductEditProtocol: OpenMarketService, ProductDeleteable, ProductModifyable {}
