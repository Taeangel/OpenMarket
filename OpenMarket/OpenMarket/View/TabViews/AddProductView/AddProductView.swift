//
//  AddProductView.swift
//  OpenMarket
//
//  Created by song on 2022/12/25.
//

import SwiftUI
import Photos

struct AddProductView: View {
  @StateObject var vm: AddProductViewModel = AddProductViewModel()
  @State var showPicker: Bool = false
  var body: some View {
    VStack {
      Text("상품등록")
        .font(.title3)
        .fontWeight(.bold)
        .foregroundColor(Color.theme.black)
      
      imageView
      
      Spacer()
    }
    .popupImagePocker(show: $showPicker) { assets in
      let manager = PHCachingImageManager.default()
      let option = PHImageRequestOptions()
      option.isSynchronous = true
      DispatchQueue.global(qos: .userInteractive).async {
        assets.forEach { asset in
          manager.requestImage(for: asset,
                               targetSize: .init(),
                               contentMode: .default,
                               options: option) { image, _ in
            guard let image = image else { return }
            DispatchQueue.main.async {
              print("\(image.scale )")
              self.vm.images.append(image)
            }
          }
        }
      }
    }
  }
  
  var imagePickerView: some View {
    ZStack{
      Rectangle()
        .fill(Color(uiColor: UIColor.systemGray6))
        .frame(width: 100, height: 100, alignment: .center)
        .cornerRadius(10)
      VStack {
        Image(systemName: "photo.on.rectangle")
          .padding(6)
          .foregroundColor(Color(uiColor: UIColor.gray))
        Text("\(vm.images.count)/\(5)")
          .foregroundColor(Color(uiColor: UIColor.gray))
      }
    }
  }
  
  var imageView: some View {
    ScrollView(.horizontal) {
      HStack {
        ForEach(Array(vm.images.enumerated()), id: \.offset) { (index, image) in
          ZStack(alignment: .topTrailing) {
            Image(uiImage: image)
              .resizable()
              .frame(width: 100, height: 100)
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
  }
}

struct AddProductView_Previews: PreviewProvider {
  static var previews: some View {
    AddProductView()
  }
}
