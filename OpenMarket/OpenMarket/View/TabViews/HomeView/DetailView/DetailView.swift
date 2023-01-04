//
//  DetailView.swift
//  OpenMarket
//
//  Created by song on 2022/12/24.
//

import SwiftUI

struct DetailView: View {
  
  @EnvironmentObject var coordinator: Coordinator<openMarketRouter>
  @StateObject var vm: DetailViewModel
  
  var body: some View {
    VStack {
      top
      
      images
      
      information
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    .background {
      Color.theme.background
        .ignoresSafeArea()
    }
  }
}

fileprivate extension DetailView {
  private var top: some View {
    HStack {
      Button {
        withAnimation {
          coordinator.pop()
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
        vm.tapHeart()
      } label: {
        Image(systemName: vm.favoriteProduct ? "suit.heart.fill" : "suit.heart")
          .foregroundColor(Color.theme.red)
          .padding(12)
          .background {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
              .fill(Color.theme.white)
          }
      }
    }
    .padding()
  }
  
  private var images: some View {
    
    ScrollView(.horizontal) {
      HStack {
        ForEach(vm.product?.images ?? []) { images in
          ImageView(url: images.imageURL)
            .frame(height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 30))
        }
      }
    }
  }
  
  private var information: some View {
    VStack(alignment: .leading) {
      
      HStack(spacing: 10) {
        VStack(alignment: .leading) {
          Text(vm.product?.name ?? "")
            .font(.title.bold())
            .foregroundColor(Color.theme.black)
            .fixedSize()
            .lineLimit(1)
          
          Text("\(vm.product?.moneySign ?? "")\(vm.product?.price ?? 0)")
            .font(.title3.bold())
            .strikethrough()
            .foregroundColor(Color.theme.failColor)
          
          Text("\(vm.product?.moneySign ?? "")\(vm.product?.discountedPrice ?? 0)")
            .font(.title.bold())
            .foregroundColor(Color.theme.red)
        }
        
        Text("수량: \(vm.product?.stock ?? 0)")
          .font(.callout)
          .foregroundColor(Color.theme.black)
          .multilineTextAlignment(.leading)
          .padding(.vertical)
        
        Spacer()
        
        HStack(spacing: 10) {
          Image(systemName: "minus")
            .onTapGesture {
              if vm.cartCount > 0 {
                vm.cartCount -= 1
              }
            }
          Text("\(vm.cartCount)")
          
          Image(systemName: "plus")
            .onTapGesture {
              vm.cartCount += 1
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
      
      Text(vm.product?.productDescription ?? "")
        .font(.callout)
        .foregroundColor(Color.theme.secondaryText)
        .multilineTextAlignment(.leading)
        .padding(.vertical)

      Spacer(minLength: 5)
      
      Rectangle()
        .fill(Color.theme.black.opacity(0.1))
        .frame(height: 1)
      
      HStack {
        Text("\(vm.totolPrice)")
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
  }
}
