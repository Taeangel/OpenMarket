//
//  ModiftView.swift
//  OpenMarket
//
//  Created by song on 2022/12/27.
//

import SwiftUI

struct ModiftView: View {
  @EnvironmentObject private var coordinator: Coordinator<openMarketRouter>
  @StateObject var vm: ModifyViewModel
  
  var body: some View {
    top
    ZStack {
      Form {
        
        images
        
        infomationSection
        
        registerButtonView
      }
      
      if vm.showAlert {
        CustomAlertView(show: $vm.showAlert, isSuccess: vm.isPostSuccess, completion: vm.alertMessage) {
          coordinator.dismiss()
        }
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    .background {
      Color.theme.background
        .ignoresSafeArea()
    }
  }
}

fileprivate extension ModiftView {
  private var top: some View {
    HStack {
      Button {
        withAnimation {
          coordinator.dismiss()
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
      
      Text("수정화면 입니다")
        .foregroundColor(Color.theme.red)
      
      Spacer()
      
    }
    .padding()
  }
  
  private var images: some View {
    ScrollView(.horizontal) {
      HStack {
        ForEach(vm.imageURL) { images in
          ImageView(url: images.imageURL)
            .frame(height: 150)
            .clipShape(RoundedRectangle(cornerRadius: 30))
        }
      }
    }
  }
  
  private var infomationSection: some View {
    Section {
      HStack {
        Text("상품이름: ")
        TextField("상품이름", text: $vm.productName)
      }
      
      HStack {
        Text("가격: ")
        TextField("가격", text: $vm.price)
        
        Picker("", selection: $vm.currency) {
          ForEach(Currency.allCases, id: \.self) { currency in
            Text(currency.rawValue)
          }
        }
      }
      HStack {
        Text("할인할 가격: ")
        TextField("할인할 가격", text:$vm.discountPrice )
      }
      
      HStack {
        Text("수량: ")
        TextField("수량", text: $vm.stock)
      }
      
      HStack {
        Text("제품 설명: ")
        TextField(vm.productDescription, text: $vm.productDescription)
      }
      
    } header: {
      Text("제품정보")
    } footer: {
      Text("\(vm.informationError)")
        .foregroundColor(Color.theme.red)
        .opacity(vm.informationError == "" ? 0 : 1)
    }
  }
  
  private var registerButtonView: some View {
    Button {
      vm.modifyProduct()
    } label: {
      Text("상품수정")
    }
    .disabled(!vm.postButtonisValid)
  }
}
