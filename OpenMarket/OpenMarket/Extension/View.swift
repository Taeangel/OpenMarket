//
//  Extension.swift
//  ImagePicker
//
//  Created by song on 2022/12/25.
//

import SwiftUI
import Photos

extension View {
  @ViewBuilder
  func popupImagePocker(show: Binding<Bool>,transition: AnyTransition = .move(edge: .bottom) ,onSelect: @escaping ([PHAsset]) -> ()) -> some View {
    self
      .overlay {
        
        ZStack {
          
          Rectangle()
            .fill(.ultraThinMaterial)
            .ignoresSafeArea()
            .opacity(show.wrappedValue ? 1 : 0)
            .onTapGesture {
              show.wrappedValue = false
            }
          
          if show.wrappedValue {
            PopupImagePockerView {
              show.wrappedValue = false
            } onSalect: { assets in
              onSelect(assets)
              show.wrappedValue = false
            }.transition(transition)
          }
          

        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .animation(.easeInOut, value: show.wrappedValue)
    }
  }
}
