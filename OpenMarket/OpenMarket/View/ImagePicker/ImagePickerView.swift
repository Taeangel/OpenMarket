//
//  PopupImagePockerView.swift
//  ImagePicker
//
//  Created by song on 2022/12/25.
//

import SwiftUI
import Photos

struct PopupImagePockerView: View {
  @StateObject var vm: ImagePickerViewModel = ImagePickerViewModel()
  @Environment(\.self) var env
  
  var onEnd: () -> ()
  var onSalect: ([PHAsset]) -> ()
  
  var body: some View {
    VStack(spacing: 0) {
      HStack {
        Text("Select Image")
          .font(.callout.bold())
          .frame(maxWidth: .infinity, alignment: .leading)
        
        Button {
          onEnd()
        } label: {
          Image(systemName: "xmark.circle.fill")
            .font(.title3)
            .foregroundColor(.primary)
        }
      }
      .padding(.horizontal)
      .padding(.top)
      .padding(.bottom, 10)
      
      ScrollView(.vertical, showsIndicators:  false) {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4),spacing: 12) {
          ForEach($vm.fetchedImages) { $imageAsset in
            GridContent(imageAsset: imageAsset)
              .onAppear {
                if imageAsset.thumbnail == nil {
                  let manager = PHCachingImageManager.default()
                  manager.requestImage(for: imageAsset.asset,
                                       targetSize: CGSize(width: 100, height: 100),
                                       contentMode: .aspectFill,
                                       options: nil) { image, _ in
                    imageAsset.thumbnail = image
                  }
                }
              }
          }
        }
        .padding( )
      }
      .safeAreaInset(edge: .bottom) {
        Button {
          let imageAsset = vm.selectedImages.compactMap { imageAsset -> PHAsset? in
            return imageAsset.asset
          }
          onSalect(imageAsset)
        } label: {
          Text("Add\(vm.selectedImages.isEmpty ? "" : "\(vm.selectedImages.count) Images")")
            .font(.callout)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, 30)
            .padding(.vertical, 10)
            .background {
              Capsule()
                .fill(Color.theme.blue)
            }
        }
        .disabled(vm.selectedImages.isEmpty)
        .opacity(vm.selectedImages.isEmpty ? 0.6 : 1)
        .padding(.vertical)
        
      }
    }
    .frame(height: UIScreen.main.bounds.size.height / 1.8)
    .frame(maxWidth: (UIScreen.main.bounds.width - 40) > 350 ? 305 : (UIScreen.main.bounds.width - 40))
    .background {
      RoundedRectangle(cornerRadius: 10, style: .continuous)
        .fill(env.colorScheme == .dark ? .black : .white)
    }
    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
  }
  
  @ViewBuilder
  func GridContent(imageAsset: ImageAsset) -> some View {
    GeometryReader { proxy in
      let size = proxy.size
      ZStack {
        if let  thumbnail = imageAsset.thumbnail {
          Image(uiImage: thumbnail)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size.width, height: size.height)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

        } else {
          ProgressView()
            .frame(width: size.width, height: size.height, alignment: .center)
        }
        
        ZStack {
          RoundedRectangle(cornerRadius: 8, style: .continuous)
            .fill(.black.opacity(0.1))
          
          Circle()
            .fill(.white.opacity(0.25))
          
          Circle()
            .stroke(.white, lineWidth: 1)
          
          if let index = vm.selectedImages.firstIndex(where: { asset in
            asset.id == imageAsset.id
          }) {
            Circle()
              .fill(.blue)
            Text("\(vm.selectedImages[index].assetIndex + 1)")
              .font(.caption2.bold())
              .foregroundColor(.white)
          }
        }
        .frame(width: 20, height: 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing )
        .padding(5)
      }
      .clipped()
      .onTapGesture {
        withAnimation(.easeOut) {
          if let index = vm.selectedImages.firstIndex(where: { $0.id == imageAsset.id }) {
            vm.selectedImages.remove(at: index)
            vm.selectedImages.enumerated().forEach { item in
              vm.selectedImages[item.offset].assetIndex = item.offset
            }
          } else {
            var newAsset = imageAsset
            newAsset.assetIndex = vm.selectedImages.count
            vm.selectedImages.append(newAsset)
          }
          
          if vm.selectedImages.count > 5 {
            vm.selectedImages.remove(at: 0)
            vm.selectedImages.enumerated().forEach { item in
              vm.selectedImages[item.offset].assetIndex = item.offset
            }
          }
        }
      }
    }
    .frame(height: 70)
  }
}

