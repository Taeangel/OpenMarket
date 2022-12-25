//
//  TextFieldView.swift
//  OpenMarket
//
//  Created by song on 2022/12/25.
//

import SwiftUI

struct SearchBarView: View {
  
  @Binding var seachText: String
  
  
  var body: some View {
    HStack {
      Image(systemName: "magnifyingglass")
        .foregroundColor(
          seachText.isEmpty ? Color.theme.secondaryText : Color.theme.accent )
      
      TextField("Search by name or symbol...", text: $seachText)
        .foregroundColor(Color.theme.accent)
        .autocorrectionDisabled()
        .overlay(alignment: .trailing) {
          Image(systemName: "xmark.circle.fill")
            .padding()
            .offset(x: 10)
            .foregroundColor(Color.theme.accent)
            .opacity(seachText.isEmpty ? 0.0 : 1.0)
            .onTapGesture {
              UIApplication.shared.endEditing()
              seachText = ""
            }
        }
    }
    .font(.headline)
    .padding()
    .background(
      RoundedRectangle(cornerRadius: 4)
        .fill(Color.theme.background)
        .shadow(color: Color.theme.accent.opacity(0.15), radius: 10, x: 0, y: 0)
    )
    .padding()
  }
}

struct SearchBarView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      SearchBarView(seachText: .constant(""))
    }
  }
}
