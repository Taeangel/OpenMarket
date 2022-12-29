//
//  NetWorkManager.swift
//  OpenMarket
//
//  Created by song on 2022/12/23.
//
import UIKit
import Foundation

//https://openmarket.yagom-academy.kr/api/products?page_no=1&items_per_page=20  == getProductList
//https://openmarket.yagom-academy.kr/api/products/32 == getProduct
//https://openmarket.yagom-academy.kr/api/products == postProduct
//https://openmarket.yagom-academy.kr/api/products?page_no=1&items_per_page=100&search_value=red  == get myProductList
//https://openmarket.yagom-academy.kr/api/products/1610/archived == productDeletionURISearch
//https://openmarket.yagom-academy.kr/api/products//api/products/MTYyNHw4M2I2YWNiNC04NTc4LTExZWQtYmUxMC03M2U3MGRlNWY4YjA= == deleteProduct
//https://openmarket.yagom-academy.kr/api/products/1624 == modifyProduct

// var identifier: String = "81da9d11-4b9d-11ed-a200-81a344d1e7cb"
// var secret: String = "bjv33pu73cbajp1"
// var userName: String = "red123"

enum OpenMarketRequestManager {
  
  case getProductList(page_no: Int = 1, items_per_page: Int = 20)
  case getProduct(_ id: Int)
  case postProduct(params: Product, images: [Data])
  case getMyProductList(page_no: Int = 1, items_per_page: Int = 10, search_value: String = "red")
  case productDeletionURISearch(id: Int)
  case deleteProduct(endpoint: String)
  case modifyProduct(id: Int, product: Product)
  
  private var BaseURLString: String {
    return "https://openmarket.yagom-academy.kr"
  }
  
  private var endPoint: String {
    switch self {
    case .getProductList:
      return "/api/products?"
    case .getProduct(let id) :
      return "/api/products/\(id)"
    case .postProduct:
      return "/api/products"
    case .getMyProductList:
      return "/api/products?"
    case let .productDeletionURISearch(id):
      return "/api/products/\(id)/archived"
    case let .deleteProduct(endpoint):
      return "\(endpoint)"
    case let .modifyProduct(id, _):
      return "/api/products/\(id)/"
    }
  }
  
  private var method: HTTPMethod {
    switch self {
    case .getProductList:
      return .get
    case .getProduct:
      return .get
    case .postProduct:
      return .post
    case .getMyProductList:
      return .get
    case .productDeletionURISearch:
      return .post
    case .deleteProduct:
      return .delete
    case .modifyProduct:
      return .patch
    }
  }
  
  private var parameters: [String: Any]? {
    switch self {
    case let .getProductList(page_no, items_per_page):
      var params: [String: Any] = [:]
      params["page_no"] = page_no
      params["items_per_page"] = items_per_page
      return params
    case .getProduct:
      return nil
    case .postProduct:
      return nil
    case let .getMyProductList(page_no, items_per_page, search_value):
      var params: [String: Any] = [:]
      params["page_no"] = page_no
      params["items_per_page"] = items_per_page
      params["search_value"] = search_value
      return params
    case .productDeletionURISearch:
      return nil
    case .deleteProduct:
      return nil
    case .modifyProduct:
      return nil
    }
  }
  
  private var headerFields: [String: String]? {
    switch self {
    case .getProductList:
      return nil
    case .getProduct:
      return nil
    case let .postProduct(params, _):
      return ["identifier": "81da9d11-4b9d-11ed-a200-81a344d1e7cb", "Content-Type": "multipart/form-data; boundary=\(params.boundary)"]
    case .getMyProductList:
      return nil
    case .productDeletionURISearch:
      return ["identifier": "81da9d11-4b9d-11ed-a200-81a344d1e7cb", "Content-Type": "application/json"]
    case .deleteProduct:
      return ["identifier": "81da9d11-4b9d-11ed-a200-81a344d1e7cb"]
    case .modifyProduct:
      return ["identifier": "81da9d11-4b9d-11ed-a200-81a344d1e7cb", "Content-Type" : "application/json"]
    }
  }
  
  private var form: Data? {
    switch self {
    case .getProductList:
      return nil
    case .getProduct:
      return nil
    case let .postProduct(params, images):
      let paramsData = try? JSONEncoder().encode(params)
      var multipartFormParts: [Datapart] = []
      images.forEach { multipartFormParts.append(Datapart(name: "images", data: $0, filename: "", contentType: "image/jpeg"))}
      multipartFormParts.append(Datapart(name: "params", data: paramsData ?? Data(), filename: "", contentType: "application/json"))
      return MultipartForm(parts: multipartFormParts, boundary: params.boundary).bodyData
    case .getMyProductList:
      return nil
    case .productDeletionURISearch:
      return try? JSONEncoder().encode(Secret())
    case .deleteProduct:
      return nil
    case let .modifyProduct(_, product):
      return try? JSONEncoder().encode(product)
    }
  }
  
  var urlRequest: URLRequest {
    var components = URLComponents(string: BaseURLString + endPoint)
    
    if let parameters {
      components?.queryItems = parameters.map { key, value in
        URLQueryItem(name: key, value: "\(value)")
      }
    }
    
    var request = URLRequest(url: (components?.url) ?? URL(fileURLWithPath: ""))
    request.httpMethod = method.rawValue
    
    if let headerFields {
      headerFields.forEach {
        request.addValue($0.value, forHTTPHeaderField: $0.key)
      }
    }
    
    if let form  {
      request.httpBody = form
    }
  
    return request
  }
}

