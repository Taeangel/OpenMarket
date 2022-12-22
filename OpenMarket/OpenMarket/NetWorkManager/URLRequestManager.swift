//
//  NetWorkManager.swift
//  OpenMarket
//
//  Created by song on 2022/12/23.
//

import Foundation
//https://openmarket.yagom-academy.kr/api/products?page_no=1&items_per_page=20  == getProductList

enum OpenMarketRequestManager {

  private var BaseURLString: String {
    return "https://openmarket.yagom-academy.kr/"
  }
  
  case getProductList(page_no: Int = 1, items_per_page: Int = 20)
  
  private var endPoint: String {
    switch self {
    case .getProductList:
      return "api/products?"
    }
  }
  
  private var method: HTTPMethod {
    switch self {
    case .getProductList:
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
    }
  }
  
  private var allHTTPHeaderFields: [String: String] {
    switch self {
    case .getProductList:
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
