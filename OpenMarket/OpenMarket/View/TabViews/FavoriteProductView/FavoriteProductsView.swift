//
//  FavoriteProductsView.swift
//  OpenMarket
//
//  Created by song on 2022/12/29.
//

import SwiftUI

struct FavoriteProductsView: View {
  @StateObject var vm: FavoriteProductViewModel
  @EnvironmentObject var coordinator: Coordinator<openMarketRouter>
  init(allPorductListService: AllProductListService, favoriteCoinDataService: FavoriteCoinDataService) {
    self._vm = StateObject(wrappedValue: FavoriteProductViewModel(productListService: allPorductListService, favoriteCoinDataService: favoriteCoinDataService))
  }
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      
      VStack(spacing: 15) {
        title
        
        cell
      }
      .padding()
      .padding(.bottom, 100)
    }
    .background(Color.theme.background)
  }
}

struct FavoriteProductsView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
  }
}

extension FavoriteProductsView {
  private var title: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("MyProduct")
        .font(.title.bold())
    }
    .foregroundColor(Color.theme.black)
    .frame(maxWidth: .infinity, alignment: .leading)
  }
  
  private var cell: some View {
    ForEach(vm.productList ?? []) { page in
      CardView(page: page)
    }
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
    .padding(.bottom, 6)
  }
}
