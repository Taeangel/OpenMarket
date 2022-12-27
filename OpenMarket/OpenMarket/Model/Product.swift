//
//  Product.swift
//  OpenMarket
//
//  Created by song on 2022/12/26.
//

import Foundation

struct Product: Encodable {
  let name: String
  let description: String
  let price: Int
  let currency: String
  let discountedPrice: Int
  let stock: Int
  let secret: String = "bjv33pu73cbajp1"
  let boundary: String = UUID().uuidString
  
  enum CodingKeys: String, CodingKey {
    case name
    case description
    case price
    case currency
    case discountedPrice = "discounted_price"
    case stock
    case secret
  }
}
