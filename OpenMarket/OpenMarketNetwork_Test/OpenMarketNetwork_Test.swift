//
//  OpenMarketNetwork_Test.swift
//  OpenMarketNetwork_Test
//
//  Created by song on 2023/01/02.
//

import XCTest
@testable import OpenMarket
import Combine
import SwiftUI

final class OpenMarketNetwork_Test: XCTestCase {
  var cancellable = Set<AnyCancellable>()
  var product: ProductModel? = nil
  var productList: [Product] = []
  
  override func setUpWithError() throws {
    
  }
  
  override func tearDownWithError() throws {
    product = nil
    productList = []
    cancellable.removeAll()
  }
  
  func test_ApiManager_requestPublisherGetProduct_shouldBeWork() {
    //when
    let expectation = XCTestExpectation(description: "개별조회")
    let id = 10
    //then
    ApiManager.shared.requestPublisher(.getProduct(id))
      .sink(receiveCompletion: ApiManager.shared.handleCompletion) { [weak self] returnedProduct in
        self?.product = try? JSONDecoder().decode(ProductModel.self, from: returnedProduct)
        expectation.fulfill()
      }
      .store(in: &cancellable)
    //given
    wait(for: [expectation], timeout: 3)
    XCTAssertEqual(product?.id, 10)
  }
  
  func test_ApiManager_requestPublisherGetProductList_shouldBeWork() {
    //when
    let expectation = XCTestExpectation(description: "리스트 조회")
    let page_no = 1
    let items_per_page = 20
    //then
    ApiManager.shared.requestPublisher(.getProductList(page_no: page_no, items_per_page: items_per_page))
    
      .sink(receiveCompletion: ApiManager.shared.handleCompletion) { [weak self] returnedProduct in
        self?.productList = try! JSONDecoder().decode(ProductListModel.self, from: returnedProduct).pages!
        expectation.fulfill()
      }
      .store(in: &cancellable)
    //given
    wait(for: [expectation], timeout: 3)
    XCTAssertEqual(productList.count, 20)
  }
  
  func test_ApiManager_requestPublisherPostProduct_shouldBeWork() {
    //when
    let expectation = XCTestExpectation(description: "포스트 조회")

    let product = ProductEncodeModel(name: "테스트입니다아아아아아",
                                     description: "설명이다아아아아아아",
                                     price: 10,
                                     currency: "KRW",
                                     discountedPrice: 5,
                                     stock: 5)
    
    let imageData = UIImage(systemName: "pencil")?.jpegData(compressionQuality: 0.1) ?? Data()
     
    //then
    ApiManager.shared.requestPublisher(.postProduct(params: product, images: [imageData]))
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: ApiManager.shared.handleCompletion) { [weak self] data in
        self?.product = try? JSONDecoder().decode(ProductModel.self, from: data)
        expectation.fulfill()
      }
      .store(in: &cancellable)
    //given
    wait(for: [expectation], timeout: 2)
    XCTAssertEqual(product.price, 10)
  }
  
  func test_ApiManager_requestPublishermodifyProduct_shouldBeWork() {
    //when
    let expectation = XCTestExpectation(description: "포스트 조회")

    let product = ProductEncodeModel(name: "테스트입니다아아아아아",
                                     description: "설명이다아아아아아아",
                                     price: 10,
                                     currency: "KRW",
                                     discountedPrice: 5,
                                     stock: 5)
     
    //then
    ApiManager.shared.requestPublisher(.modifyProduct(id: 1683, product: product))
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: ApiManager.shared.handleCompletion) { [weak self] data in
        self?.product = try? JSONDecoder().decode(ProductModel.self, from: data)
        expectation.fulfill()
      }
      .store(in: &cancellable)
    //given
    wait(for: [expectation], timeout: 2)
    XCTAssertEqual(product.price, 10)
  }
  
//  func test_ApiManager_requestPublishermodifyProduct_shouldBeWork() {
//    //when
//    let expectation = XCTestExpectation(description: "포스트 조회")
//
//    let product = ProductEncodeModel(name: "테스트입니다아아아아아",
//                                     description: "설명이다아아아아아아",
//                                     price: 10,
//                                     currency: "KRW",
//                                     discountedPrice: 5,
//                                     stock: 5)
//
//    //then
//    ApiManager.shared.requestPublisher(.productDeletionURISearch(id: <#T##Int#>))
//      .receive(on: DispatchQueue.main)
//      .sink(receiveCompletion: ApiManager.shared.handleCompletion) { [weak self] data in
//        self?.product = try? JSONDecoder().decode(ProductModel.self, from: data)
//        expectation.fulfill()
//      }
//      .store(in: &cancellable)
//    //given
//    wait(for: [expectation], timeout: 2)
//    XCTAssertEqual(product.price, 10)
//  }
//
}
