//
//  AddProductView.swift
//  OpenMarket
//
//  Created by song on 2022/12/25.
//

import SwiftUI
import Photos

struct AddProductView: View {
  @StateObject var vm: AddProductViewModel
  @State var showPicker: Bool = false
  
  var body: some View {
    ZStack {
      Form {
        addProductText
        
        imageView
        
        infomationSection
        
        addProductButton
      }
      
      if vm.showAlert {
        CustomAlertView(show: $vm.showAlert, isSuccess: vm.isPostSuccess, completion: vm.alertMessage)
      }
    }
    .popupImagePocker(show: $showPicker) { assets in
      let manager = PHCachingImageManager.default()
      let option = PHImageRequestOptions()
      option.isSynchronous = true
      DispatchQueue.global(qos: .userInteractive).async {
        var images: [UIImage] = []
        assets.forEach { asset in
          manager.requestImage(for: asset,
                               targetSize: .init(),
                               contentMode: .default,
                               options: option) { image, _ in
            guard let image = image else { return }
            images.append(image)
          }
        }
        DispatchQueue.main.async {
          self.vm.images = images
        }
      }
    }
  }
}

struct AddProductView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
  }
}


fileprivate extension AddProductView {
  private var addProductText: some View {
    Text("상품등록")
      .font(.title3)
      .fontWeight(.bold)
      .foregroundColor(Color.theme.black)
  }
  
  private var imagePickerView: some View {
    ZStack{
      Rectangle()
        .fill(Color(uiColor: UIColor.systemGray6))
        .frame(height: 150, alignment: .center)
        .frame(minWidth: 150)
        .cornerRadius(10)
      VStack {
        Image(systemName:vm.images.count != 5 ? "photo.on.rectangle" : "arrow.left.arrow.right")
          .padding(6)
          .foregroundColor( Color.theme.secondaryText)
        Text(vm.images.count != 5 ? "\(vm.images.count)/\(5)" : "imageChange")
          .foregroundColor(Color.theme.secondaryText)
      }
    }
  }
  
  private var infomationSection: some View {
    Section {
      TextField("상품이름", text: $vm.productName)
      HStack {
        TextField("가격", text: $vm.price)
        
        Picker("", selection: $vm.currency) {
          ForEach(Currency.allCases, id: \.self) { currency in
            Text(currency.rawValue)
          }
        }
      }
      
      TextField("할인할 가격", text:$vm.discountPrice )
      TextField("상품수량", text: $vm.stock)
      TextField("제품설명", text: $vm.productDescription)
    } header: {
      Text("제품정보")
    } footer: {
      Text("\(vm.informationError)")
        .foregroundColor(Color.theme.red)
        .opacity(vm.informationError == "" ? 0 : 1)
    }
  }
  
  private var imageView: some View {
    ScrollView(.horizontal) {
      HStack {
        ForEach(Array(vm.images.enumerated()), id: \.offset) { (index, image) in
          ZStack(alignment: .topTrailing) {
            Image(uiImage: image)
              .resizable()
              .frame(height: 150)
              .frame(maxWidth: 200)
              .cornerRadius(10)
            Button {
              vm.images.remove(at: index)
            } label: {
              Image(systemName: "xmark.circle.fill")
                .foregroundColor(.red)
            }
          }
        }
        Button {
          showPicker.toggle()
        } label: {
          imagePickerView
        }
      }
    }
    .scrollIndicators(.hidden)
  }
  
  private var addProductButton: some View {
    Button {
      vm.postProduct()
    } label: {
      Text("상품등록")
    }
    .disabled(!vm.postButtonisValid)
  }
}
