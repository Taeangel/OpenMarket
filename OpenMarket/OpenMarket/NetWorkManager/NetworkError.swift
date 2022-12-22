//
//  NetworkError.swift
//  OpenMarket
//
//  Created by song on 2022/12/23.
//

import Foundation

enum NetworkErrorError: Error {
  case network(error: Error)
  case decoding(error: Error)
  case unknown
  case unauthorized
  case noContent
  case badStatus(code: Int)
}
