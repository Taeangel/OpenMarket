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
  
  func test_OpenMarket_TapMyView_shouldBeWork1() {
    //given
    
    let app = XCUIApplication()
    let searchTextField = app.textFields["Search"]
    searchTextField.tap()
    
    let qKey = app/*@START_MENU_TOKEN@*/.keys["Q"]/*[[".keyboards.keys[\"Q\"]",".keys[\"Q\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
    qKey.tap()
    qKey.tap()
    
    let wKey = app/*@START_MENU_TOKEN@*/.keys["w"]/*[[".keyboards.keys[\"w\"]",".keys[\"w\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
    wKey.tap()
    wKey.tap()
    app.buttons["Edit"].tap()
    searchTextField.tap()
    
    let deleteKey = app/*@START_MENU_TOKEN@*/.keys["delete"]/*[[".keyboards.keys[\"delete\"]",".keys[\"delete\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
    deleteKey.tap()
    deleteKey.tap()
    deleteKey.tap()
    
    //when
    
    //then
  }
}
