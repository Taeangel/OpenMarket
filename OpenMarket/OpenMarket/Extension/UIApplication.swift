//
//  UIApplication.swift
//  OpenMarket
//
//  Created by song on 2022/12/25.
//

import SwiftUI

extension UIApplication {
  func endEditing() {
    sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}
