//
//  ImageAsset.swift
//  ImagePicker
//
//  Created by song on 2022/12/25.
//

import SwiftUI
import PhotosUI

struct ImageAsset: Identifiable {
  var id: String = UUID().uuidString
  var asset: PHAsset
  var thumbnail: UIImage?
  var assetIndex: Int = -1
}
