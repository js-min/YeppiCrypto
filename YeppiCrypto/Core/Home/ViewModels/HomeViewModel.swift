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
//    dataService.$allCoins
//      .sink { [weak self] returnedCoins in
//        self?.allCoins = returnedCoins
//      }
//      .store(in: &cancellables)
    
    // updates all Coins
    $searchText
      .combineLatest(dataService.$allCoins) // subscribe searchText AND allCoins
      .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
      .map(filterCoins)
      .sink { [weak self] returnedCoins in
        self?.allCoins = returnedCoins
      }
      .store(in: &cancellables)
  }
  
  private func filterCoins(text: String, coins: [Coin]) -> [Coin] {
    guard !text.isEmpty else {
      return coins
    }
    
    let lowerCasedText = text.lowercased()
    return coins.filter( { coin -> Bool in
      return coin.name.lowercased().contains(lowerCasedText) ||
        coin.symbol.lowercased().contains(lowerCasedText) ||
        coin.id.lowercased().contains(lowerCasedText)
    })
  }
  
}
