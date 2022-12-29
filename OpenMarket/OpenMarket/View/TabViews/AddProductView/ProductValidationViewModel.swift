//
//  ProductValidationViewModel.swift
//  OpenMarket
//
//  Created by song on 2022/12/29.
//

import Foundation
import Combine
import SwiftUI

class ProductValidationViewModel: ObservableObject {
  @Published var images: [UIImage] = []
  @Published var productName: String = ""
  @Published var price: String = ""
  @Published var discountPrice: String = ""
  @Published var stock: String = ""
  @Published var productDescription: String = ""
  @Published var informationError: String = ""
  @Published var postButtonisValid: Bool = false
  @Published var currency: Currency = .KRW
  @Published var product: ProductModel?
  var cancellable = Set<AnyCancellable>()
 
   func makeProduct() -> ProductEncodeModel {
    return ProductEncodeModel(name: productName,
                  description: discountPrice,
                  price: Int(price) ?? 1,
                  currency: currency.rawValue,
                  discountedPrice: Int(discountPrice) ?? 0,
                  stock: Int(stock) ?? 1)
  }
  
   func addSubscriber() {
    isProductInformationVailidPublisher
      .dropFirst()
      .receive(on: RunLoop.main)
      .map { informationValid in
        switch informationValid {
        case .valid:
          return ""
        case .imageEmpty:
          return "이미지를 업로드 해주세요"
        case .productCharacterRange:
          return "제품명은 3자이상 입력해 주세요"
        case .priceEmpty:
          return "가격을 입력해주세요"
        case .discountPriceOver:
          return "할인가를 수정해주세요"
        case .stockEmpty:
          return "수량을 입력해 주세요"
        case .productDescriptionCharacterRange:
          return "설명을 입력해 주세요"
        }
      }
      .assign(to: \.informationError, on: self)
      .store(in: &cancellable)
    
    isFormValidPublsher
      .receive(on: RunLoop.main)
      .assign(to: \.postButtonisValid, on: self)
      .store(in: &cancellable)
  }
  
  private var isImageCountVailidPublisher: AnyPublisher<Bool, Never> {
    $images
      .debounce(for: 0.5, scheduler: RunLoop.main)
      .map { $0.count > 0 }
      .eraseToAnyPublisher()
  }
   
  private var isProductNameVailidPublisher: AnyPublisher<Bool, Never> {
    $productName
      .debounce(for: 0.5, scheduler: RunLoop.main)
      .map { $0.count >= 3}
      .eraseToAnyPublisher()
  }
  
  private var isPriceVailidPublisher: AnyPublisher<Bool, Never> {
    $price
      .debounce(for: 0.5, scheduler: RunLoop.main)
      .map { Int($0) ?? 0 }
      .map { $0 > 0 }
      .eraseToAnyPublisher()
  }
  
  private var isDiscountPriceVailidPublisher: AnyPublisher<Bool, Never> {
    $discountPrice
      .debounce(for: 0.5, scheduler: RunLoop.main)
      .combineLatest($price)
      .map { Int($0) ?? 0 <= Int($1) ?? 0 }
      .eraseToAnyPublisher()
  }
  
  private var isStockVailidPublisher: AnyPublisher<Bool, Never> {
    $stock
      .debounce(for: 0.5, scheduler: RunLoop.main)
      .map { Int($0) ?? 0 }
      .map { $0 > 0 }
      .eraseToAnyPublisher()
  }
  
  private var isProductDescriptionVailidPublisher: AnyPublisher<Bool, Never> {
    $productDescription
      .debounce(for: 0.5, scheduler: RunLoop.main)
      .map { $0.count >= 1 }
      .eraseToAnyPublisher()
  }
  
  private var isProductInformationVailidPublisher: AnyPublisher<ProductStatus, Never> {
    let paramsOne = Publishers.CombineLatest3(isImageCountVailidPublisher, isProductNameVailidPublisher, isPriceVailidPublisher)
    let paramsTwo = Publishers.CombineLatest3(isDiscountPriceVailidPublisher, isStockVailidPublisher, isProductDescriptionVailidPublisher)
    
    return paramsOne.combineLatest(paramsTwo)
      .debounce(for: 0.5, scheduler: RunLoop.main)
      .map {
        if !$0.0 { return ProductStatus.imageEmpty }
        if !$0.1 { return ProductStatus.productCharacterRange }
        if !$0.2 { return ProductStatus.priceEmpty }
        if !$1.0 { return ProductStatus.discountPriceOver }
        if !$1.1 { return ProductStatus.stockEmpty }
        if !$1.2 { return ProductStatus.productDescriptionCharacterRange }
        return ProductStatus.valid
      }
      .eraseToAnyPublisher()
  }
  
  private var isFormValidPublsher: AnyPublisher<Bool, Never> {
    isProductInformationVailidPublisher
      .map { $0 == ProductStatus.valid }
      .eraseToAnyPublisher()
  }
}
