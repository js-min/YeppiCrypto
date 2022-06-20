//
//  CoinDetailDataService.swift
//  YeppiCrypto
//
//  Created by JISU MIN on 2022/06/21.
//

import Foundation
import Combine

class CoinDetailDataService {
  
  @Published var coinDetail: CoinDetail? = nil
  
  var coinSubscription: AnyCancellable?
  let coin: Coin
  
  init(coin: Coin) {
    self.coin = coin
    getCoinDetail()
  }
  
  func getCoinDetail() {
    guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false") else { return }
    
    coinSubscription = NetworkManager.download(url: url)
      .decode(type: CoinDetail.self, decoder: JSONDecoder())
      .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] (returnedCoinDetail) in
        self?.coinDetail = returnedCoinDetail
        self?.coinSubscription?.cancel()
      })
  }
}
