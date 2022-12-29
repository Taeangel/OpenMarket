//
//  Color.swift
//  OpenMarket
//
//  Created by song on 2022/12/23.
//


import Foundation
import SwiftUI

extension Color {
  static let theme = ColorTheme()
}

struct ColorTheme {
  let accent = Color("AccentColor")
  let background = Color("BackgroundColor")
  let blue = Color("BlueColor")
  let red = Color("RedColor")
  let secondaryText = Color("SecondaryTextColor")
  let black = Color("BlackColor")
  let white = Color("WhiteColor")
  let tabBarBackground = Color("TabBarBackground")
  let ImageBackgroundColor = Color("ImageBackgroundColor")
  let yellow = Color("YellowColor")
}

extension Data {
  mutating func appendString(_ stringValue: String) {
    if let data = stringValue.data(using: .utf8) {
      self.append(data)
    }
  }
}
