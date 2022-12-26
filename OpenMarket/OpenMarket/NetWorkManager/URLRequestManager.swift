//
//  NetWorkManager.swift
//  OpenMarket
//
//  Created by song on 2022/12/23.
//
import UIKit
import Foundation
import MultipartForm

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
  
  private var allHTTPHeaderFields: [String: String] {
    switch self {
    case .getProductList:
      return ["Content-Type": "application/json"]
    case .getProduct:
      return ["Content-Type": "application/json"]
    case let .postProduct(params, _):
      return ["Content-Type": "multipart/form-data; boundary=\(params.boundary)", "identifier": "81da9d11-4b9d-11ed-a200-81a344d1e7cb"]
    }
  }
  
  private var form: Data? {
    switch self {
    case .getProductList:
      return nil
    case .getProduct:
      return nil
    case let .postProduct(params, images):
      return makeMultiPartFormData(params: params, images: images)
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

    request.httpBody = form
    
    return request
  }
}

extension OpenMarketRequestManager {
  private func makeMultiPartFormData(params: Param, images: [Data]) -> Data {
    let productData = try? JSONEncoder().encode(params)
    
    var data = Data()
    let boundary = params.boundary
    
    let newLine = "\r\n"
    let boundaryPrefix = "--\(boundary)\r\n"
    let boundarySuffix = "\r\n--\(boundary)--\r\n"
    
    data.appendString(boundaryPrefix)
    data.appendString("Content-Disposition: form-data; name=\"params\"\r\n")
    data.appendString("Content-Type: application/json\r\n")
    data.appendString("\r\n")
    data.append(productData ?? Data())
    data.appendString(newLine)
    
    images.forEach { imageData in
      data.appendString(boundaryPrefix)
      data.appendString("Content-Disposition: form-data; name=\"images\"; filename=\"\(1231).jpg\"\r\n")
      data.appendString("Content-Type: image/jpg\r\n\r\n")
      data.append(imageData)
      data.appendString(newLine)
    }
    data.appendString(boundarySuffix)
    
    return data
  }
}
