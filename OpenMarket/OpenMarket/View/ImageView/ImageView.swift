//
//  ImageView.swift
//  OpenMarket
//
//  Created by song on 2022/12/23.
//

import SwiftUI

struct ImageView: View {
  @StateObject private var vm: ImageViewModel

  
  init(url: URL) {
    _vm = StateObject(wrappedValue: ImageViewModel(url: url))
  }
  
  var body: some View {
    ZStack {
      if let image = vm.image {
        Image(uiImage: image)
          .resizable()
          .scaledToFit()
      } else if vm.isLoading {
        ProgressView()
      } else {
        Image(systemName: "questionmark")
          .foregroundColor(Color.theme.secondaryText)
      }
    }
  }
}
