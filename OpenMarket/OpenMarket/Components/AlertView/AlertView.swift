//
//  AlertView.swift
//  OpenMarket
//
//  Created by song on 2022/12/30.
//

import Foundation
import SwiftUI

struct BlurView: UIViewRepresentable {
  
  func makeUIView(context: Context) -> UIVisualEffectView {
    let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
    return view
  }
  
  func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
    
  }
}

struct CustomAlertView: View {
  @Binding var show: Bool
  let isSuccess: Bool
  let completion: String
  let okButton: () -> ()
  
  var body: some View {
    ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)) {
      VStack(spacing: 25) {
        Text(isSuccess ? "đđđđđđđđ" : "đ°đ°đ°đ°đ°đ°đ°")
        
        Text(isSuccess ? "ěąęłľíěľëë¤!" : "ě¤í¨íěľëë¤ă")
          .font(.title)
          .foregroundColor(isSuccess ? Color.theme.blue : Color.theme.failColor)
        
        Text(completion)
        
        Button(action: {
          withAnimation {
            show.toggle()
          }
          okButton()
        },
               label: {
          Text("íě¸")
            .foregroundColor(.white)
            .fontWeight(.bold)
            .padding(.vertical, 10)
            .padding(.horizontal, 25)
            .background(Color.theme.red)
            .clipShape(Capsule())
        })
      }
      .padding(.vertical, 25)
      .padding(.horizontal, 30)
      .background(BlurView())
      .cornerRadius(25)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(
      Color.primary.opacity(0.35)
    )
  }
}
