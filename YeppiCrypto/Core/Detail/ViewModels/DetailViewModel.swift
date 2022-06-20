//
//  DetailViewModel.swift
//  YeppiCrypto
//
//  Created by JISU MIN on 2022/06/21.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
  
  private let coinDetailService: CoinDetailDataService
  
  private var cancellables = Set<AnyCancellable>()
  
  init(coin: Coin) {
    self.coinDetailService = CoinDetailDataService(coin: coin)
    addSubscriber()
  }
  
  private func addSubscriber() {
    coinDetailService.$coinDetail
      .sink { returnedCoinDetail in
        print(returnedCoinDetail)
      }
      .store(in: &cancellables)
  }
}
