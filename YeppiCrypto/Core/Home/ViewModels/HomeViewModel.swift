//
//  HomeViewModel.swift
//  YeppiCrypto
//
//  Created by JISU MIN on 2022/06/13.
//

import Foundation

class HomeViewModel: ObservableObject {
  
  @Published var allCoins: [Coin] = []
  @Published var portfolioCoins: [Coin] = []
  
  init() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
      self.allCoins.append(DeveloperPreview.instance.coin)
      self.portfolioCoins.append(DeveloperPreview.instance.coin)
    }
  }
  
}
