//
//  OpenMarketRequestMnanger_Test.swift
//  OpenMarketRequestMnanger_Test
//
//  Created by song on 2023/01/02.
//

import XCTest
@testable import OpenMarket
import Combine

// Naming Structure: test_[struct or class]_[variable or [function]_[expected result]

final class OpenMarketRequestMnanger_Test: XCTestCase {
  let baseURL = "https://openmarket.yagom-academy.kr"
  override func setUpWithError() throws {
    
  }
  
  override func tearDownWithError() throws {
    
  }
  
  func test_OpenMarketRequestManager_getProduct_shouldBeEqual() {
    //when
    let id = 200
    //then
    let getProductURL = OpenMarketRequestManager.getProduct(id).urlRequest
    //given
    
    XCTAssertEqual(getProductURL.description, baseURL + "/api/products/200")
    XCTAssertEqual(getProductURL.httpMethod, "GET")
    XCTAssertEqual(getProductURL.allHTTPHeaderFields, [:])
    XCTAssertEqual(getProductURL.httpBody, nil)
  }
  
  func test_OpenMarketRequestManager_getProductList_shouldBeEqual() {
    //when
    let page_no = 1
    let items_per_page = 20
    //then
    let getProductListURL = OpenMarketRequestManager.getProductList(page_no: page_no, items_per_page: items_per_page).urlRequest
    //given
    XCTAssertEqual(getProductListURL.description, baseURL + "/api/products?page_no=1&items_per_page=20")
    XCTAssertEqual(getProductListURL.httpMethod, "GET")
    XCTAssertEqual(getProductListURL.allHTTPHeaderFields, [:])
    XCTAssertEqual(getProductListURL.httpBody, nil)
  }
  
  func test_OpenMarketRequestManager_postProduct_shouldBeEqual() {
    //when
    let product = ProductEncodeModel(name: "테스트",
                                     description: "설명",
                                     price: 6,
                                     currency: "USD",
                                     discountedPrice: 5,
                                     stock: 5)
    let imageData = UIImage().jpegData(compressionQuality: 1) ?? Data()
    //then
    let postProductURL = OpenMarketRequestManager.postProduct(params: product, images: [imageData]).urlRequest
    //given
    XCTAssertEqual(postProductURL.description, baseURL + "/api/products")
    XCTAssertEqual(postProductURL.httpMethod, "POST")
    XCTAssertEqual(postProductURL.allHTTPHeaderFields?.isEmpty, false)
    XCTAssertEqual(postProductURL.httpBody?.isEmpty, false)
  }
  
  func test_OpenMarketRequestManager_ProductEncodeModel_shouldBeEqual() {
    //when
    let id = 100
    let product = ProductEncodeModel(name: "테스트",
                                     description: "설명",
                                     price: 6,
                                     currency: "USD",
                                     discountedPrice: 5,
                                     stock: 5)
    //then
    let modifyProductURL = OpenMarketRequestManager.modifyProduct(id: id, product: product).urlRequest
    //given
    XCTAssertEqual(modifyProductURL.description, baseURL + "/api/products/100/")
    XCTAssertEqual(modifyProductURL.httpMethod, "PATCH")
    XCTAssertEqual(modifyProductURL.allHTTPHeaderFields?.isEmpty, false)
    XCTAssertEqual(modifyProductURL.httpBody?.isEmpty, false)
  }
  
  func test_OpenMarketRequestManager_productDeletionURISearch_shouldBeEqual() {
    //when
    let id = 100
    //then
    let productDeletionURISearchURL = OpenMarketRequestManager.productDeletionURISearch(id: id).urlRequest
    //given
    XCTAssertEqual(productDeletionURISearchURL.description, baseURL + "/api/products/100/archived")
    XCTAssertEqual(productDeletionURISearchURL.httpMethod, "POST")
    XCTAssertEqual(productDeletionURISearchURL.allHTTPHeaderFields?.isEmpty, false)
    XCTAssertEqual(productDeletionURISearchURL.httpBody?.isEmpty, false)
  }
}
