//
//  Provider.swift
//  OpenMarket
//
//  Created by song on 2022/12/23.
//

import Foundation
import Combine

struct Provider {
  static let shared = Provider()
  private init() {}
  
  func requestPublisher(_ request: OpenMarketRequestManager) -> AnyPublisher<Data, NetworkErrorError> {
    return URLSession.shared.dataTaskPublisher(for: request.asURLRequest)
      .tryMap(filterURLData)
      .mapError(convertToNetworkError)
      .eraseToAnyPublisher()
  }
  
  func handleCompletion(completion: Subscribers.Completion<NetworkErrorError>) {
    switch completion {
    case .finished:
      break
    case .failure(let error):
      print(error.localizedDescription)
    }
  }
}

extension Provider {
  
  private func convertToNetworkError(err: Error) -> NetworkErrorError {
    if let error = err as? NetworkErrorError {
      return error
    }
    if let error = err as? DecodingError {
      return NetworkErrorError.decoding(error: error)
    }
    return NetworkErrorError.unknown
  }
  
  private func filterURLData(data: Data, urlResponse: URLResponse) throws -> Data {
    
    guard let httpResponse = urlResponse as? HTTPURLResponse else {
      throw NetworkErrorError.unknown
    }
    
    switch httpResponse.statusCode {
    case 401:
      throw NetworkErrorError.unauthorized
    case 204:
      throw NetworkErrorError.noContent
    default:
      print("default")
    }
    
    if !(200...299).contains(httpResponse.statusCode) {
      throw NetworkErrorError.badStatus(code: httpResponse.statusCode)
    }
    
    return data
  }
}
