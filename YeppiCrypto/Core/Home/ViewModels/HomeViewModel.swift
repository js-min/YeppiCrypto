//
//  HomeViewModel.swift
//  YeppiCrypto
//
//  Created by JISU MIN on 2022/06/13.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
  
  @Published var allCoins: [Coin] = []
  @Published var portfolioCoins: [Coin] = []
  
  @Published var searchText: String = ""
  
  private let dataService = CoinDataService()
  
  private var cancellables = Set<AnyCancellable>()
  
  init() {
    addSubscribers()
  }
  
  func addSubscribers() {
    dataService.$allCoins
      .sink { [weak self] returnedCoins in
        self?.allCoins = returnedCoins
      }
      .store(in: &cancellables)
  }
  
}
