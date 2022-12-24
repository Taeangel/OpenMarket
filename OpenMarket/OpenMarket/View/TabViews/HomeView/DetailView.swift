//
//  DetailView.swift
//  OpenMarket
//
//  Created by song on 2022/12/24.
//

import SwiftUI

struct DetailView: View {
  var product: Page
  var animation: Namespace.ID
  @EnvironmentObject var vm: MainViewModel
  @State var showDetailContent: Bool = false
  @State var cartCount: Int = 0
  var body: some View {
    GeometryReader { proxy in
      let size = proxy.size
      
      VStack {
        HStack {
          Button {
            withAnimation(.easeInOut) {
              showDetailContent = false
            }
            withAnimation(.easeInOut.delay(0.05)) {
              vm.showDetailView = false
            }
          } label: {
            Image(systemName: "chevron.left")
              .foregroundColor(Color.theme.black)
              .padding(12)
              .background {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                  .fill(Color.theme.white)
              }
          }
          
          Spacer()
          
          Button {
            
          } label: {
            Image(systemName: "suit.heart.fill")
              .foregroundColor(Color.theme.red)
              .padding(12)
              .background {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                  .fill(Color.theme.white)
              }
          }
        }
        .padding()
        .opacity(showDetailContent ? 1 : 0)
        
        ImageView(url: product.thumbnailURL)
          .matchedGeometryEffect(id: "\(String(describing: product.id))" + "IMAGE", in: animation)
          .frame(height: size.height / 3)
          .clipShape(RoundedRectangle(cornerRadius: 30))
        
        VStack(alignment: .leading) {
          
          HStack(spacing: 10) {
            VStack {
              Text(product.name ?? "")
                .font(.title.bold())
                .foregroundColor(Color.theme.black)
                .fixedSize()
                .matchedGeometryEffect(id: "\(String(describing: product.name))" + "NAME", in: animation)
                .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Label {
              Text("4.7")
                .font(.callout)
                .fontWeight(.bold)
            } icon: {
              Image(systemName: "star.fill")
                .foregroundColor(Color.theme.blue)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background {
              Capsule()
                .strokeBorder(Color.theme.black.opacity(0.2), lineWidth: 1)
            }
            .scaleEffect(0.8)

          }
          
          
          
          HStack(spacing: 10) {
            Text(product.pageDescription ?? "")
              .font(.callout)
              .foregroundColor(Color.theme.secondaryText)
              .multilineTextAlignment(.leading)
            .padding(.vertical)
            
            Spacer()
            
            HStack(spacing: 10) {
              Image(systemName: "minus")
                .onTapGesture {
                  if cartCount > 0 {
                    cartCount -= 1
                  }
                }
              Text("\(cartCount)")
              
              Image(systemName: "plus")
                .onTapGesture {
                  cartCount += 1
                }
            }
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(Color.theme.black)
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background {
              Capsule()
                .fill(Color.theme.black.opacity(0.1))
            }
          }
          
          Spacer(minLength: 5)
          
          Rectangle()
            .fill(Color.theme.black.opacity(0.1))
            .frame(height: 1)
          
          HStack {
            Text("\(product.discountedPrice ?? 0)")
              .font(.largeTitle.bold())
              .foregroundColor(Color.theme.black)
        
            Spacer()
            
            Button {
              
            } label: {
              Text("Buy Now")
                .fontWeight(.semibold)
                .foregroundColor(Color.theme.white)
                .padding(.vertical)
                .padding(.horizontal, 30)
                .background {
                  Capsule()
                    .fill(Color.theme.red)
                }
            }

        
          }
          .padding(.bottom, 5)
          
          

        }
        .padding(.top, 35)
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background {
          RoundedRectangle(cornerRadius: 30, style: .continuous)
            .fill(Color.theme.white)
            .ignoresSafeArea()
        }
        .opacity(vm.showDetailView ? 1 : 0)

      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
      
    }
    .background {
      Color.theme.background
        .ignoresSafeArea()
        .opacity(showDetailContent ? 1 : 0)
    }
    .onAppear {
      withAnimation(.easeInOut) {
        showDetailContent = true
      }
    }
  }
}

struct DetailView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
  }
}
