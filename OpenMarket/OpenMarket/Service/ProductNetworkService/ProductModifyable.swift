//
//  ProductModifyable.swift
//  OpenMarket
//
//  Created by song on 2023/01/09.
//

import Foundation
import Combine

protocol ProductModifyable: OpenMarketService {
  func modifyProduct(id: Int, product: ProductEncodeModel) -> AnyPublisher<Data, NetworkError>
}

extension ProductModifyable {
  func modifyProduct(id: Int, product: ProductEncodeModel) -> AnyPublisher<Data, NetworkError> {
    pageNumber = 2
    
    return openMarketNetwork.requestPublisher(.modifyProduct(id: id, product: product))
      .flatMap { [weak self] _ in
        self?.openMarketNetwork.requestPublisher(.getMyProductList()) ?? Empty(completeImmediately: true).eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()
  }
}
