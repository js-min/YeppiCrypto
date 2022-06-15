//
//  CoinImageService.swift
//  YeppiCrypto
//
//  Created by JISU MIN on 2022/06/15.
//

import Foundation
import SwiftUI
import Combine

class CoinImageService {
  
  @Published var image: UIImage? = nil
  
  private var imageSubscription: AnyCancellable?
  private let coin: Coin
  private let fileManager = LocalFileManager.instance
  private let folderName = "coin_images"
  private let imageName: String
  
  init(coin: Coin) {
    self.coin = coin
    self.imageName = coin.id
    getCoinImage()
  }
  
  private func getCoinImage() {
    if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
      print("DEBUG: retrieved image from File Manager")
      image = savedImage
    } else {
      downloadCoinImage()
    }
  }
  
  private func downloadCoinImage() {
    print("DEBUG: download image now")
    guard let url = URL(string: coin.image) else { return }
    
    imageSubscription = NetworkManager.download(url: url)
      .tryMap({ (data) -> UIImage? in
        return UIImage(data: data)
      })
      .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] returnedImage in
        guard
          let self = self,
          let downloadedImage = returnedImage
        else { return }
        self.image = downloadedImage
        self.imageSubscription?.cancel()
        self.fileManager.saveImage(image: downloadedImage, imageName: self.imageName, folderName: self.folderName)
      })
  }
  
}
