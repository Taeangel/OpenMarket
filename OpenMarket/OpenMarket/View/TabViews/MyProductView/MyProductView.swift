//
//  MyProductView.swift
//  OpenMarket
//
//  Created by song on 2022/12/27.
//

import SwiftUI

struct MyProductView: View {
  @StateObject var vm: MyProductViewModel
  @EnvironmentObject private var coordinator: Coordinator<openMarketRouter>
  
  var body: some View {
    ZStack {
      ScrollView(.vertical, showsIndicators: false) {
        
        VStack(spacing: 15) {
          title
          
          cell
        }
        .padding()
        .padding(.bottom, 100)
      }
      
      if vm.showAlert {
        CustomAlertView(show: $vm.showAlert, isSuccess: vm.isPostSuccess, completion: vm.alertMessage) {
          
        }
      }
    }
    .background(Color.theme.background)
  }
}

struct MyProductView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
  }
}

fileprivate extension MyProductView {
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
                .strikethrough()
                .foregroundColor(Color.theme.failColor)
                .font(.title3)
                .foregroundColor(Color.theme.black)
              
              Text(page.discountedPriceString)
                .font(.title.bold())
                .foregroundColor(Color.theme.red)
            }
            
            Spacer()
            VStack {
              Button {
                vm.deleteProduct(page.id ?? 0)
              } label: {
                Text("??????")
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
                coordinator.show(.modify(product: page))
              } label: {
                Text("??????")
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

  }
}
