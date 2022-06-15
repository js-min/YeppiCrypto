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
  
  init(coin: Coin) {
    self.coin = coin
    getCoinImage()
  }
  
  private func getCoinImage() {
    guard let url = URL(string: coin.image) else { return }
    
    imageSubscription = NetworkManager.download(url: url)
      .tryMap({ (data) -> UIImage? in
        return UIImage(data: data)
      })
      .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] returnedImage in
        self?.image = returnedImage
        self?.imageSubscription?.cancel()
      })
  }
  
}
