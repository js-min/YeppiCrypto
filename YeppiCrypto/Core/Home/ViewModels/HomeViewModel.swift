//
//  HomeViewModel.swift
//  YeppiCrypto
//
//  Created by JISU MIN on 2022/06/13.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
  
  @Published var statistics: [StatisticModel] = []
  
  @Published var allCoins: [Coin] = []
  @Published var portfolioCoins: [Coin] = []
  
  @Published var searchText: String = ""
  
  private let coinDataService = CoinDataService()
  private let marketDataService = MarketDataService()
  private let portfolioDataService = PortfolioDataService()
  
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
      .combineLatest(coinDataService.$allCoins) // subscribe searchText AND allCoins
      .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
      .map(filterCoins)
      .sink { [weak self] returnedCoins in
        self?.allCoins = returnedCoins
      }
      .store(in: &cancellables)
    
    // updates market data
    marketDataService.$marketData
      .map(mapGlobalMarketData)
      .sink { [weak self] returendStats in
        self?.statistics = returendStats
      }
      .store(in: &cancellables)
    
    // updates portfolioCoins
    $allCoins
      .combineLatest(portfolioDataService.$savedEntities)
      .map { (coins, portfolioEntities) -> [Coin] in
        coins.compactMap { coin -> Coin? in
          guard let entity = portfolioEntities.first(where: { $0.coinId == coin.id }) else { return nil }
          return coin.updateHoldings(amount: entity.amount)
        }
      }
      .sink { [weak self] returnedCoins in
        self?.portfolioCoins = returnedCoins
      }
      .store(in: &cancellables)
      
  }
  
  func updatePortfolio(coin: Coin, amount: Double) {
    portfolioDataService.updatePortfolio(coin: coin, amount: amount)
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
  
  private func mapGlobalMarketData(marketDataModel: MarketData?) -> [StatisticModel] {
    var stats: [StatisticModel] = []
    guard let data = marketDataModel else { return stats }
    let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
    let volume = StatisticModel(title: "24h Volume", value: data.volume)
    let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
    let portfolio = StatisticModel(title: "Portfolio Value", value: "$0.00", percentageChange: 0)
    stats.append(contentsOf: [
      marketCap,
      volume,
      btcDominance,
      portfolio
    ])
    return stats
  }
  
}
