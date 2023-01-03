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
  var mockSession: Requestable!
  var mockFailSession: Requestable!

  override func setUpWithError() throws {
    mockSession = MockSession()
    mockFailSession = MockFailSession()
  }
  
  override func tearDownWithError() throws {
    mockSession = nil
    mockFailSession = nil
    product = nil
    productList = []
    cancellable.removeAll()
  }
  
  func test_ApiManager_requestPublisherGetProduct_shouldBeWork() {
    //when
    let openMarketNetwork = ApiManager(session: URLSession.shared)
    let expectation = XCTestExpectation(description: "개별조회")
    let id = 10
    //then
    openMarketNetwork.requestPublisher(.getProduct(id))
      .sink(receiveCompletion: openMarketNetwork.handleCompletion) { [weak self] returnedProduct in
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
    let openMarketNetwork = ApiManager(session: URLSession.shared)
    let expectation = XCTestExpectation(description: "리스트 조회")
    let page_no = 1
    let items_per_page = 20
    //then
    openMarketNetwork.requestPublisher(.getProductList(page_no: page_no, items_per_page: items_per_page))
    
      .sink(receiveCompletion: openMarketNetwork.handleCompletion) { [weak self] returnedProduct in
        self?.productList = try! JSONDecoder().decode(ProductListModel.self, from: returnedProduct).product!
        expectation.fulfill()
      }
      .store(in: &cancellable)
    //given
    wait(for: [expectation], timeout: 3)
    XCTAssertEqual(productList.count, 20)
  }
  
  
  //이테스트는 테스트를 할 때마다 openData를 오염시키는 문제가 발생함
  func test_ApiManager_requestPublisherPostProduct_shouldBeWork() {
    //when
    let openMarketNetwork = ApiManager(session: URLSession.shared)
    let expectation = XCTestExpectation(description: "포스트 조회")

    let product = ProductEncodeModel(name: "테스트입니다아아아아아",
                                     description: "설명이다아아아아아아",
                                     price: 10,
                                     currency: "KRW",
                                     discountedPrice: 5,
                                     stock: 5)
    
    let imageData = UIImage(systemName: "pencil")?.jpegData(compressionQuality: 0.1) ?? Data()
     
    //then
    openMarketNetwork.requestPublisher(.postProduct(params: product, images: [imageData]))
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion:openMarketNetwork.handleCompletion) { [weak self] data in
        self?.product = try? JSONDecoder().decode(ProductModel.self, from: data)
        expectation.fulfill()
      }
      .store(in: &cancellable)
    //given
    wait(for: [expectation], timeout: 2)
    XCTAssertEqual(product.price, 10)
  }
  
  //이테스트는 테스트를 할 때마다 openData를 오염시키는 문제가 발생함
  func test_ApiManager_requestPublishermodifyProduct_shouldBeWork() {
    //when
    let openMarketNetwork = ApiManager(session: URLSession.shared)
    let expectation = XCTestExpectation(description: "포스트 조회")

    let product = ProductEncodeModel(name: "테스트입니다아아아아아",
                                     description: "설명이다아아아아아아",
                                     price: 10,
                                     currency: "KRW",
                                     discountedPrice: 5,
                                     stock: 5)
     
    //then
    openMarketNetwork.requestPublisher(.modifyProduct(id: 1683, product: product))
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion:openMarketNetwork.handleCompletion) { [weak self] data in
        self?.product = try? JSONDecoder().decode(ProductModel.self, from: data)
        expectation.fulfill()
      }
      .store(in: &cancellable)
    //given
    wait(for: [expectation], timeout: 2)
    XCTAssertEqual(product.price, 10)
  }
  
  func test_ApiManager_requestPublisher_getProductList_shouldBeWork() {
    //when
    let openMarketNetwork = ApiManager(session: mockSession)
    let expectation = XCTestExpectation(description: "getProductList 조회")
    let page_no = 1
    let items_per_page = 20
    //then
    openMarketNetwork.requestPublisher(.getProductList(page_no: page_no, items_per_page: items_per_page))
      .sink(receiveCompletion: openMarketNetwork.handleCompletion) { result in
        expectation.fulfill()
      }
      .store(in: &cancellable)
    
    //given
    wait(for: [expectation], timeout: 2)
  }
  
  func test_ApiManager_requestPublisher_getProduct_shouldBeWork() {
    //when
    let openMarketNetwork = ApiManager(session: mockSession)
    let expectation = XCTestExpectation(description: "getProduct 조회")

    //then
    openMarketNetwork.requestPublisher(.getProduct(24))
      .sink(receiveCompletion: openMarketNetwork.handleCompletion) { result in
        expectation.fulfill()
      }
      .store(in: &cancellable)
    
    //given
    wait(for: [expectation], timeout: 2)
  }
  
  func test_ApiManager_requestPublisher_productDeletionURISearch_shouldBeWork() {
    //when
    let openMarketNetwork = ApiManager(session: mockSession)
    let expectation = XCTestExpectation(description: "productDeletionURISearch 조회")

    //then
    openMarketNetwork.requestPublisher(.productDeletionURISearch(id: 14))
      .sink(receiveCompletion: openMarketNetwork.handleCompletion) { result in
        expectation.fulfill()
      }
      .store(in: &cancellable)
    
    //given
    wait(for: [expectation], timeout: 2)
  }
  
  func test_ApiManager_requestPublisher_deleteProduct_shouldBeWork() {
    //when
    let openMarketNetwork = ApiManager(session: mockSession)
    let expectation = XCTestExpectation(description: "productDeletionURISearch 조회")

    //then
    openMarketNetwork.requestPublisher(.productDeletionURISearch(id: 25))
      .sink(receiveCompletion: openMarketNetwork.handleCompletion) { data in
        guard let deleteURL = String(data: data, encoding: .utf8) else { return }
        openMarketNetwork.requestPublisher(.deleteProduct(endpoint: deleteURL))
          .sink(receiveCompletion: openMarketNetwork.handleCompletion) { result in
            expectation.fulfill()
          }
      }
      .store(in: &cancellable)
    
    //given
    wait(for: [expectation], timeout: 2)
  }
  
  func test_ApiManager_requestPublisher_modifyProduct_shouldBeWork() {
    //when
    let openMarketNetwork = ApiManager(session: mockSession)
    let expectation = XCTestExpectation(description: "modifyProduct 조회")
    let product = ProductEncodeModel(name: "목객체", description: "입니다아아아", price: 100, currency: "USD", discountedPrice: 10, stock: 10)

    //then
    openMarketNetwork.requestPublisher(.modifyProduct(id: 14, product: product))
      .sink(receiveCompletion: openMarketNetwork.handleCompletion) { result in
        expectation.fulfill()
      }
      .store(in: &cancellable)
    
    //given
    wait(for: [expectation], timeout: 2)
  }
  
  func test_ApiManager_requestPublisher_modifyProduct_shouldBeFail() {
    //when
    let openMarketNetwork = ApiManager(session: mockFailSession)
    let expectation = XCTestExpectation(description: "modifyProduct 조회")

    //then
    openMarketNetwork.requestPublisher(.getProduct(14))
      .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
          break
        case .failure:
          expectation.fulfill()
        }
      }, receiveValue: { result in
        XCTFail()
      })
      .store(in: &cancellable)
    
    //given
    wait(for: [expectation], timeout: 2)
  }
  
}

