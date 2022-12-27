//
//  MyProductView.swift
//  OpenMarket
//
//  Created by song on 2022/12/27.
//

import SwiftUI

struct MyProductView: View {
  @StateObject var vm: MyProductViewModel = MyProductViewModel()
  @EnvironmentObject var coordinator: Coordinator<openMarketRouter>

  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      
      VStack(spacing: 15) {
        title
        
        SearchBarView(seachText: $vm.searchText)
        
        cell
      }
      .padding()
      .padding(.bottom, 100)
    }
    .background(Color.theme.background)
  }
}

struct MyProductView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
  }
}

extension MyProductView {
  private var title: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("MyProduct")
        .font(.title.bold())
    }
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
    ForEach(vm.productList?.pages ?? []) { page in
      CardView(page: page)
    }
  }
  
  @ViewBuilder
  func CardView(page: Page) -> some View {
    
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
            VStack {
              Button {
                vm.deleteProduct(page.id ?? 0)
              } label: {
                Text("삭제")
                  .font(.callout)
                  .fontWeight(.semibold)
                  .foregroundColor(Color.theme.white)
                  .padding(.horizontal, 20)
                  .padding(.vertical, 5)
                  .background {
                    RoundedRectangle(cornerRadius: 8)
                      .fill(Color.theme.red)
                  }
              }
              
              Button {
                coordinator.show(.modift(product: page))
              } label: {
                Text("수정")
                  .font(.callout)
                  .fontWeight(.semibold)
                  .foregroundColor(Color.theme.white)
                  .padding(.horizontal, 20)
                  .padding(.vertical, 5)
                  .background {
                    RoundedRectangle(cornerRadius: 8)
                      .fill(Color.theme.blue)
                  }
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
        coordinator.show(.detail(product: page))
      }
    }
    .padding(.bottom, 6)
  }
}
