//
//  ImagePickerViewModel.swift
//  ImagePicker
//
//  Created by song on 2022/12/25.
//

import Foundation
import PhotosUI

class ImagePickerViewModel: ObservableObject {
  @Published var fetchedImages: [ImageAsset] = []
  @Published var selectedImages: [ImageAsset] = []
  
  init() {
    fetchImages()
  }
  
  func fetchImages() {
    let option = PHFetchOptions()
    
    option.includeHiddenAssets = false
    option.includeAssetSourceTypes = [.typeUserLibrary]
    option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    PHAsset.fetchAssets(with: .image, options: option).enumerateObjects { asset, _, _ in
      let imageAsset: ImageAsset = .init(asset: asset)
      self.fetchedImages.append(imageAsset)
    }
  }
}
