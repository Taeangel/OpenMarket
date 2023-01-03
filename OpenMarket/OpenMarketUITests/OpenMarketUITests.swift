//
//  OpenMarketUITests.swift
//  OpenMarketUITests
//
//  Created by song on 2023/01/03.
//

import XCTest

final class OpenMarketUITests: XCTestCase {
  let app = XCUIApplication()
  
  override func setUpWithError() throws {
    continueAfterFailure = false
    app.launch()
  }
  
  override func tearDownWithError() throws {
  }
  
  func testLaunchPerformance() throws {
    if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
      // This measures how long it takes to launch your application.
      measure(metrics: [XCTApplicationLaunchMetric()]) {
        XCUIApplication().launch()
      }
    }
  }
  
  func test_OpenMarket_TapAddView_shouldBeWork() {
    //given
    
    //when
    app.buttons["arrow.up.square"].tap()
    //then
    app.collectionViews/*@START_MENU_TOKEN@*/.staticTexts["상품등록"]/*[[".cells.staticTexts[\"상품등록\"]",".staticTexts[\"상품등록\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
  }
  
  func test_OpenMarket_TapMyView_shouldBeWork() {
    //given
    
    //when
    app.buttons["Account"].tap()
    //then
    app.scrollViews.otherElements.staticTexts["MyProduct"].tap()
    
  }
  
  func test_OpenMarket_AllTapMyView_shouldBeWork() {
    // given
    let addTabBarButton = app.buttons["arrow.up.square"]
    let accountTabBarbuttpn = app.buttons["Account"]
    let myProductProduct = app.scrollViews.otherElements.staticTexts["MyProduct"]
    // when
    addTabBarButton.tap()
    accountTabBarbuttpn.tap()
    // then
    XCTAssertTrue(myProductProduct.exists)
  }
  
  func test_OpenMarket_HomeView_searchSholdBeWork() {
    // given
    let textField = app.textFields["Search"]
    let returnButton = app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards.buttons[\"Return\"]",".buttons[\"Return\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
    //when
    textField.tap()
    returnButton.tap()
    
    //then
    app.scrollViews.children(matching: .other).element.children(matching: .other).element.children(matching: .image).element(boundBy: 0).tap()
  }
  
  func test_OpenMarket_MyProductView_appearEditView() {
    // given
    let accountButton = app.buttons["Account"]
    let editButton = app.scrollViews.otherElements.children(matching: .button).matching(identifier: "수정").element(boundBy: 0)
    let editText = app.staticTexts["수정화면 입니다"]
    // when
    accountButton.tap()
    editButton.tap()
    // then
    XCTAssertTrue(editText.exists)
  }
  
  func test_OpenMarket_DetailView_appearDetailView() {
    // given
    let product = app.scrollViews.children(matching: .other).element.children(matching: .other).element.children(matching: .image).element(boundBy: 1)
    let productTitleText = app.staticTexts["ttt"]
    // when
    product.tap()
    // then
    
    XCTAssertTrue(productTitleText.exists)
  }
  
  func test_OpenMarket_RegisterView_appearRegisterView() {
    // given
    let registerViewButton = app.buttons["arrow.up.square"]
    let registetProductTitle = app.collectionViews/*@START_MENU_TOKEN@*/.staticTexts["상품등록"]/*[[".cells.staticTexts[\"상품등록\"]",".staticTexts[\"상품등록\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
    // when
    registerViewButton.tap()
    // then
    XCTAssertTrue(registetProductTitle.exists)
    
  }
}
