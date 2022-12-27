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

// var identifier: String = "81da9d11-4b9d-11ed-a200-81a344d1e7cb"
// var secret: String = "bjv33pu73cbajp1"
// var userName: String = "red123"

enum OpenMarketRequestManager {
  
  case getProductList(page_no: Int = 1, items_per_page: Int = 20)
  case getProduct(_ id: Int)
  case postProduct(params: Param, images: [Data])
  
  private var BaseURLString: String {
    return "https://openmarket.yagom-academy.kr/"
  }
  
  private var endPoint: String {
    switch self {
    case .getProductList:
      return "api/products?"
    case .getProduct(let id) :
      return "api/products/\(id)"
    case .postProduct:
      return "api/products"
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
      let params: [String: Any] = [:]
      return params
    case .postProduct:
      let params: [String: Any] = [:]
      return params
    }
  }
  
  private var headerFields: [String: String] {
    switch self {
    case .getProductList:
      return ["Content-Type": "application/json"]
    case .getProduct:
      return ["Content-Type": "application/json"]
    case let .postProduct(params, _):
      return ["identifier": "81da9d11-4b9d-11ed-a200-81a344d1e7cb", "Content-Type": "multipart/form-data; boundary=\(params.boundary)"]
    }
  }
  
  private var form: MultipartForm? {
    switch self {
    case .getProductList:
      return nil
    case .getProduct:
      return nil
    case let .postProduct(params, images):
      
      let paramsData = try! JSONEncoder().encode(params)
      var multipartFormParts: [Datapart] = []
      images.forEach { multipartFormParts.append(Datapart(name: "images", data: $0, filename: "", contentType: "image/jpeg"))}
      multipartFormParts.append(Datapart(name: "params", data: paramsData, filename: "", contentType: "application/json"))
      return  MultipartForm(parts: multipartFormParts, boundary: params.boundary)
    }
  }
  
  var asURLRequest: URLRequest {
    var components = URLComponents(string: BaseURLString + endPoint)
    
    components?.queryItems = parameters.map { key, value in
      URLQueryItem(name: key, value: "\(value)")
    }
    
    var request = URLRequest(url: (components?.url)!)
    request.httpMethod = method.rawValue
    
    headerFields.forEach {
      request.addValue($0.value, forHTTPHeaderField: $0.key)
    }
    
    if let form = form {
      request.httpBody = form.bodyData
    }
    
    return request
  }
}
