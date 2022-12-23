//
//  ImageViewModel.swift
//  OpenMarket
//
//  Created by song on 2022/12/23.
//

import Foundation
import SwiftUI
import Combine

class ImageViewModel: ObservableObject {
  @Published var image: UIImage? = nil
  @Published var isLoading: Bool = false
  
  private let url: URL
  private let dataService: ImageService
  private var cancellables = Set<AnyCancellable>()
  
  init(url: URL) {
    self.url = url
    self.dataService = ImageService(url: url)
    self.isLoading = true
    addSubscribers()
  }
  
  private func addSubscribers() {
    dataService.$image
      .sink { [weak self] _ in
        self?.isLoading = false
      } receiveValue: { [weak self] returnedImage in
        self?.image = returnedImage
      }
      .store(in: &cancellables)
  }
}
