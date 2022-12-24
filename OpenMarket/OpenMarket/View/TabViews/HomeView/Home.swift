//
//  Home.swift
//  OpenMarket
//
//  Created by song on 2022/12/23.
//

import SwiftUI

struct Home: View {
  @EnvironmentObject var vm: MainViewModel
  
  var animation: Namespace.ID
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      VStack(spacing: 15) {
        VStack(alignment: .leading, spacing: 8) {
          Text("Best Funiture")
            .font(.title.bold())
          
          Text("Perfect Choice!")
            .font(.callout)
        }
        .foregroundColor(Color.theme.black)
        .frame(maxWidth: .infinity, alignment: .leading)
        
        HStack {
          HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
              .resizable()
              .renderingMode(.template)
              .aspectRatio(contentMode: .fit)
              .frame(width: 25, height: 25)
              .foregroundColor(Color.theme.black)
            
            TextField("Search", text: .constant(""))
          }
          .padding(.horizontal)
          .padding(.vertical, 12)
          .background{
            RoundedRectangle(cornerRadius: 10,style: .continuous)
              .fill(Color.theme.white)
          }
          
          Button {
            
          } label: {
            Image(systemName: "slider.horizontal.3")
              .resizable()
              .renderingMode(.template)
              .aspectRatio(contentMode: .fit)
              .foregroundColor(Color.theme.black)
              .frame(width: 25, height: 25)
              .padding(12)
              .background{
                RoundedRectangle(cornerRadius: 10,style: .continuous)
                  .fill(Color.theme.white)
              }
          }
        }
        
        ForEach(vm.productList?.pages ?? []) { page in
          CardView(page: page)
        }
      }
      .padding()
      .padding(.bottom, 100)
    }
    .background(Color.theme.background)
  }
  
  @ViewBuilder
  func CardView(page: Page) -> some View {
    HStack(spacing: 12) {
      
      Group {
        if vm.currentActiveItem?.id == page.id && vm.showDetailView {
          ImageView(url: page.thumbnailURL)
            .aspectRatio(contentMode: .fill)
            .opacity(0)
        } else {
          ImageView(url: page.thumbnailURL)
            .aspectRatio(contentMode: .fill)
            .matchedGeometryEffect(id: "\(String(describing: page.id))" + "IMAGE", in: animation)
        }
      }
      .frame(width: 120)
      .clipShape(
        RoundedRectangle(cornerRadius: 20)
      )
      .padding(5)
      
      Group {
        if vm.currentActiveItem?.id == page.id && vm.showDetailView {
          Text(page.name ?? "")
            .fontWeight(.bold)
            .lineLimit(1)
            .foregroundColor(Color.theme.black)
            .opacity(0)
        } else {
          Text(page.name ?? "")
            .fontWeight(.bold)
            .lineLimit(1)
            .foregroundColor(Color.theme.black)
            .matchedGeometryEffect(id: "\(String(describing: page.name))" + "NAME", in: animation)
        }
      }
      
      VStack(alignment: .leading, spacing: 10) {
        
        
        Text(page.pageDescription ?? "")
          .font(.system(size: 12))
          .lineLimit(2)
          .foregroundColor(Color.theme.secondaryText)
          .padding(.bottom, -10)
        
        HStack {
          VStack(alignment: .leading) {
            Text(page.priceString)
              .font(.title3)
              .foregroundColor(Color.theme.black)
            
            Text(page.discountedPriceString)
              .font(.title3.bold())
              .foregroundColor(Color.theme.red)
          }
          
          Spacer()
          
          Button {
            
          } label: {
            Text("Buy")
              .font(.callout)
              .fontWeight(.semibold)
              .foregroundColor(Color.theme.white)
              .padding(.vertical, 8)
              .padding(.horizontal, 20)
              .background {
                Capsule()
                  .fill(Color.theme.red)
              }
          }
        }
        .offset(y: 20)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment:  .topLeading)
    }
    .padding(10)
    .background {
      RoundedRectangle(cornerRadius: 20, style: .continuous)
        .fill(Color.theme.white)
        .shadow(color: Color.theme.black.opacity(0.08), radius: 5, x: 5, y: 5)
    }
    .onTapGesture {
      withAnimation(.easeInOut) {
        vm.currentActiveItem = page
        vm.showDetailView = true
      }
    }
    .padding(.bottom, 6)
  }
}

struct Home_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
  }
}
