//
//  ProductDeleteable.swift
//  OpenMarket
//
//  Created by song on 2023/01/09.
//

import Foundation
import Combine

protocol ProductDeleteable: OpenMarketService {
 func deleteProduct(endPoint: String) -> AnyPublisher<Data, NetworkError>
}

extension ProductDeleteable {
  func deleteProduct(endPoint: String) -> AnyPublisher<Data, NetworkError> {
    pageNumber = 2
    
    return openMarketNetwork.requestPublisher(.deleteProduct(endpoint: endPoint))
      .flatMap { [weak self] _ in
        self?.openMarketNetwork.requestPublisher(.getMyProductList()) ?? Empty(completeImmediately: true).eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()
  }
}
