//
//  ProductPostable.swift
//  OpenMarket
//
//  Created by song on 2023/01/09.
//

import Foundation
import Combine

protocol ProductPostable: OpenMarketService {
  func postProduct(parms: ProductEncodeModel, images: [Data]) -> AnyPublisher<Data, NetworkError>
}

extension ProductPostable {
  func postProduct(parms: ProductEncodeModel, images: [Data]) -> AnyPublisher<Data, NetworkError> {
    pageNumber = 2
    
    return openMarketNetwork.requestPublisher(.postProduct(params: parms, images: images))
      .flatMap { [weak self] _ in
        self?.openMarketNetwork.requestPublisher(.getMyProductList()) ?? Empty(completeImmediately: true).eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()
  }
}
