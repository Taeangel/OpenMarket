//
//  ProductListModel.swift
//  OpenMarket
//
//  Created by song on 2022/12/23.
//

import Foundation

//https://openmarket.yagom-academy.kr/api/products?page_no=1&items_per_page=1

/* {
 "pageNo": 1,
 "itemsPerPage": 1,
 "totalCount": 1141,
 "offset": 0,
 "limit": 1,
 "lastPage": 1141,
 "hasNext": true,
 "hasPrev": false,
 "pages": [
 {
 "id": 1594,
 "vendor_id": 55,
 "vendorName": "baem2",
 "name": "[나눔] 건디 나눔합니다.",
 "description": "필요없어서 나눔합니다.",
 "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/55/20221222/d9c4536781fb11edbe1003aadf723b32_thumb",
 "currency": "KRW",
 "price": 1.0,
 "bargain_price": 1.0,
 "discounted_price": 0.0,
 "stock": 1,
 "created_at": "2022-12-22T00:00:00",
 "issued_at": "2022-12-22T00:00:00"
 }
 ]
 }*/

struct ProductListModel: Codable {
  let pageNo, itemsPerPage, totalCount, offset: Int?
  let limit, lastPage: Int?
  let hasNext, hasPrev: Bool?
  let pages: [Product]?
}

// MARK: - Page
struct Product: Codable, Identifiable {
  let id, vendorID: Int?
  let vendorName, name, pageDescription: String?
  let thumbnail: String?
  let currency: String?
  let price, bargainPrice, discountedPrice, stock: Int?
  let createdAt, issuedAt: String?
  
  var thumbnailURL: URL {
    guard let tumbnailString = thumbnail, let url = URL(string: tumbnailString) else {
      return URL(fileURLWithPath: "")
    }
    return url
  }
  
  var priceString: String {
    guard let price = price else {
      return ""
    }
    return "$\(price)"
  }
  
  var discountedPriceString: String {
    guard let discountedPrice = discountedPrice else {
      return ""
    }
    return "$\(discountedPrice)"
  }
  
  
  enum CodingKeys: String, CodingKey {
    case id
    case vendorID = "vendor_id"
    case vendorName, name
    case pageDescription = "description"
    case thumbnail, currency, price
    case bargainPrice = "bargain_price"
    case discountedPrice = "discounted_price"
    case stock
    case createdAt = "created_at"
    case issuedAt = "issued_at"
  }
}
