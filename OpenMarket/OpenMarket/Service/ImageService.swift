//
//  ImageService.swift
//  OpenMarket
//
//  Created by song on 2022/12/23.
//

import Foundation
import Combine
import SwiftUI

final class ImageService {
  @Published var image: UIImage? = nil
  private var subscription: AnyCancellable?
  private var url: URL
  private let fileManager = LocalFileManager()
  private let cacheManager = CacheManager()
  private let imageName: String
  private var folerName = "Product_images"
  private let imageDownloader = ImageProvider()
  
  init(url: URL) {
    self.url = url
    self.imageName = url.description
    self.getProductImage()
  }

  private func getProductImage() {
    if let cachedImage = cacheManager.get(key: imageName) {
      image = cachedImage
    } else if let fileSavedImage = fileManager.getImage(imageName: imageName, folderName: folerName) {
      image = fileSavedImage
    } else {
      downloadProductImage()
    }
  }

  private func downloadProductImage() {
    subscription = imageDownloader.download(url: url)
      .tryMap({ data -> UIImage? in
        return UIImage(data: data)
      })
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { _ in
       
      }, receiveValue: { [weak self] returnedImage in
        guard let self = self, let returnedImage = returnedImage else { return }
        self.image = returnedImage
        self.cacheManager.add(key: self.imageName, value: returnedImage)
        self.fileManager.saveImage(image: returnedImage, imageName: self.imageName, folderName: self.folerName)
        self.subscription?.cancel()
      })
  }
}

protocol ImageDownloadable {
  func download(url: URL) -> AnyPublisher<Data, Error>
}

struct ImageProvider: ImageDownloadable {
  func download(url: URL) -> AnyPublisher<Data, Error> {
    return URLSession.shared.dataTaskPublisher(for: url)
      .tryMap({ try handleResponse(output: $0, url: url) ?? Data() })
      .retry(3)
      .eraseToAnyPublisher()
  }
  
  private func handleResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data? {
    guard let response = output.response as? HTTPURLResponse,
          response.statusCode >= 200 && response.statusCode < 300 else {
      return nil
    }
    return output.data
  }
}
