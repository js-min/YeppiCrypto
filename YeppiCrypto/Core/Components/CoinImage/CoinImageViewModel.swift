//
//  CoinImageViewModel.swift
//  YeppiCrypto
//
//  Created by JISU MIN on 2022/06/15.
//

import Foundation
import SwiftUI
import Combine

class CoinImageViewModel: ObservableObject {
  
  @Published var image: UIImage? = nil
  @Published var isLoading: Bool = false
  
  private var cancellables = Set<AnyCancellable>()
  
  private let coin: Coin
  private let dataService: CoinImageService
  
  init(coin: Coin) {
    self.coin = coin
    self.dataService = CoinImageService(coin: coin)
    addSubscribers()
  }
  
  private func addSubscribers() {
    isLoading = true
    dataService.$image
      .sink { [weak self] _ in
        self?.isLoading = false
      } receiveValue: {  [weak self] returnedImage in
        self?.image = returnedImage
      }
      .store(in: &cancellables)
  }
}
