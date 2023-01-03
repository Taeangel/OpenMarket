//
//  Home.swift
//  OpenMarket
//
//  Created by song on 2022/12/23.
//

import SwiftUI


struct Home: View {
 
  @StateObject private var vm: HomeViewModel
  @EnvironmentObject private var coordinator: Coordinator<openMarketRouter>
  @State private var isShowSearchView: Bool = true
  let favoriteProductService: FavoriteProductDataProtocol
  
  let columns: [GridItem] = [
    GridItem(.fixed(150), spacing: 50, alignment: nil),
    GridItem(.fixed(150), spacing: 50, alignment: nil)
  ]
  
  init(productListService: ProductListGetProtocol, favoriteProductService: FavoriteProductDataProtocol) {
    self.favoriteProductService = favoriteProductService
    self._vm = StateObject(wrappedValue: HomeViewModel(productListService: productListService))
  }
  
  var body: some View {
    VStack(spacing: 0) {
      title
      
      search
    
      if vm.searchText.isEmpty {
        if isShowSearchView {
          cell
        } else {
          searchText
        }
      } else {
        searchCell
      }
      Spacer()
    }
    .background(Color.theme.background)
    .onTapGesture {
      UIApplication.shared.hideKeyboard()
    }
  }
}

struct Home_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
  }
}

fileprivate extension Home {
  private var title: some View {
    Text("OpenMarket")
      .font(.title.bold())
      .foregroundColor(Color.theme.black)
      .frame(maxWidth: .infinity, alignment: .center)
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
        
        TextField("Search", text: $vm.searchText)
          .onTapGesture(perform: {
            isShowSearchView = false
          })
          .onSubmit {
            isShowSearchView = true
            vm.searchProductList()
          }
      }
      .padding(.horizontal)
      .padding(.vertical, 12)
      .background{
        RoundedRectangle(cornerRadius: 10,style: .continuous)
          .fill(Color.theme.white)
      }
      
      Button {
        vm.searchText = ""
      } label: {
        Image(systemName: "x.square")
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
      .disabled(vm.searchText.isEmpty)
    }
    .padding()
  }
    
  private var searchText: some View {
    Text("원하는 상품을 검색하세요!!!")
      .font(.title2)
      .foregroundColor(Color.theme.secondaryText)
  }
  
  private var cell: some View {
    ScrollView(showsIndicators: false) {
      LazyVGrid(columns: columns) {
        ForEach(vm.productList ?? []) { page in
          GridView(page: page)
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
  
  private var searchCell: some View {
    ScrollView(showsIndicators: false) {
      ForEach(vm.searchedProductList ?? []) { page in
        CardView(page: page)
      }
    }
  }
  
  @ViewBuilder
  func GridView(page: Product) -> some View {
    VStack(spacing: 12) {
      ImageView(url: page.thumbnailURL)
        .aspectRatio(contentMode: .fill)
        .frame(width: 150, height: 150)
        .clipShape(
          RoundedRectangle(cornerRadius: 20)
        )
      
      VStack(alignment: .leading) {
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

  }
}
