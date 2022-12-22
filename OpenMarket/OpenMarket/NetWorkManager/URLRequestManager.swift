//
//  NetWorkManager.swift
//  OpenMarket
//
//  Created by song on 2022/12/23.
//

import Foundation
//https://openmarket.yagom-academy.kr/api/products?page_no=1&items_per_page=20  == getProductList
//https://openmarket.yagom-academy.kr/api/products/32 == getProduct

enum OpenMarketRequestManager {

  case getProductList(page_no: Int = 1, items_per_page: Int = 20)
  case getProduct(_ id: Int)
  
  private var BaseURLString: String {
    return "https://openmarket.yagom-academy.kr/"
  }
  
  private var endPoint: String {
    switch self {
    case .getProductList:
      return "api/products?"
    case .getProduct(let id) :
      return "api/products/\(id)"
    }
  }
  
  private var method: HTTPMethod {
    switch self {
    case .getProductList:
      return .get
    case .getProduct:
      return .get
    }
  }
  
  private var parameters: [String: Any] {
    switch self {
    case let .getProductList(page_no, items_per_page):
      var params: [String: Any] = [:]
      params["page_no"] = page_no
      params["items_per_page"] = items_per_page
      return params
    case .getProduct:
      var params: [String: Any] = [:]
      return params
    }
  }
  
  private var allHTTPHeaderFields: [String: String] {
    switch self {
    case .getProductList:
      return ["Accept": "application/json"]
    case .getProduct:
      return ["Accept": "application/json"]
    }
  }
  
  
  var asURLRequest: URLRequest {
    var components = URLComponents(string: BaseURLString + endPoint)
    
    components?.queryItems = parameters.map { key, value in
      URLQueryItem(name: key, value: "\(value)")
    }
    
    var request = URLRequest(url: (components?.url)!)
    request.httpMethod = method.rawValue
    
    allHTTPHeaderFields.forEach {
      request.addValue($0.value, forHTTPHeaderField: $0.key)
    }
    
    return request
  }
}
