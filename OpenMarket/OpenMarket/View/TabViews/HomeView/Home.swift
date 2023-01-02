//
//  Home.swift
//  OpenMarket
//
//  Created by song on 2022/12/23.
//

import SwiftUI

struct Home: View {
  @StateObject var vm: HomeViewModel
  @EnvironmentObject var coordinator: Coordinator<openMarketRouter>
  let favoriteProductService: FavoriteProductDataService
  
  init(productListService: ProductNetworkService, favoriteProductService: FavoriteProductDataService) {
    self.favoriteProductService = favoriteProductService
    self._vm = StateObject(wrappedValue: HomeViewModel(productListService: productListService))
  }
  
  var body: some View {
    VStack(spacing: 0) {
      title
      
      SearchBarView(seachText: $vm.searchText)
      
      cell
    }
    .background(Color.theme.background)
  }
}

struct Home_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
  }
}

fileprivate extension Home {
  private var title: some View {
    Text("Choose Product")
      .font(.title.bold())
      .foregroundColor(Color.theme.black)
      .frame(maxWidth: .infinity, alignment: .leading)
  }
  
  private var search: some View {
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
  }
  
  private var cell: some View {
    ScrollView(showsIndicators: false) {
      LazyVStack {
        ForEach(vm.productList ?? []) { page in
          CardView(page: page)
            .onAppear {
              if vm.productList?.last == page {
                vm.productListService?.getProduct()
              }
            }
        }
      }
    }
    .padding(.bottom, 4)
    .padding(.horizontal, 5)
    
  }
  
  @ViewBuilder
  func CardView(page: Product) -> some View {
    HStack(spacing: 12) {
      ImageView(url: page.thumbnailURL)
        .aspectRatio(contentMode: .fill)
        .frame(width: 120)
        .clipShape(
          RoundedRectangle(cornerRadius: 20)
        )
        .padding(5)
      
      VStack(alignment: .leading, spacing: 10) {
        Text(page.name ?? "")
          .fontWeight(.bold)
          .lineLimit(1)
          .foregroundColor(Color.theme.black)
        
        
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
        coordinator.show(.detail(product: page, favoriteProductService: favoriteProductService))
      }
    }
    .padding(.bottom, 6)
  }
}
