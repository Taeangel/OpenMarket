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
  
  func requestPublisher(_ request: OpenMarketRequestManager) -> AnyPublisher<Data, NetworkError> {
    return URLSession.shared.dataTaskPublisher(for: request.urlRequest)
      .tryMap(filterURLData)
      .mapError(convertToNetworkError)
      .eraseToAnyPublisher()
  }
  
  func handleCompletion(completion: Subscribers.Completion<NetworkError>) {
    switch completion {
    case .finished:
      break
    case .failure(let error):
      print(error.localizedDescription)
    }
  }
}

extension Provider {
  
  private func convertToNetworkError(err: Error) -> NetworkError {
    if let error = err as? NetworkError {
      return error
    }
    if let error = err as? DecodingError {
      return NetworkError.decoding(error: error)
    }
    return NetworkError.unknown
  }
  
  private func filterURLData(data: Data, urlResponse: URLResponse) throws -> Data {
    
    guard let httpResponse = urlResponse as? HTTPURLResponse else {
      throw NetworkError.unknown
    }
    
    switch httpResponse.statusCode {
    case 401:
      throw NetworkError.unauthorized
    case 204:
      throw NetworkError.noContent
    default:
      print("pass")
    }
    
    if !(200...299).contains(httpResponse.statusCode) {
      throw NetworkError.badStatus(code: httpResponse.statusCode)
    }
    
    return data
  }
}
