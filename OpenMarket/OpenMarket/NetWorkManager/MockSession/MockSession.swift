//
//  Mock.swift
//  OpenMarket
//
//  Created by song on 2023/01/02.
//

import Foundation
import Combine

struct MockSession: Requestable {
  func request(_ request: OpenMarketRequestManager) -> AnyPublisher<Data, NetworkError> {
    let paramsData = try! JSONEncoder().encode(ProductEncodeModel(name: "목객체", description: "입니다아아아", price: 100, currency: "USD", discountedPrice: 10, stock: 10))
    return Just(paramsData)
      .setFailureType(to: NetworkError.self)
      .eraseToAnyPublisher()
  }
}

struct MockFailSession: Requestable {
  func request(_ request: OpenMarketRequestManager) -> AnyPublisher<Data, NetworkError> {
    return Fail(error: NetworkError.unknown)
      .eraseToAnyPublisher()
  }
}
