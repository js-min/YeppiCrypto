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
  @Published var isLoading: Bool = false
  @Published var searchText: String = ""
  @Published var sortOption: SortOption = .holdings
  
  private let coinDataService = CoinDataService()
  private let marketDataService = MarketDataService()
  private let portfolioDataService = PortfolioDataService()
  
  private var cancellables = Set<AnyCancellable>()
  
  enum SortOption {
    case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
  }
  
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
      .combineLatest(coinDataService.$allCoins, $sortOption) // subscribe searchText AND allCoins
      .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
      .map(filterAndSortCoins)
      .sink { [weak self] returnedCoins in
        self?.allCoins = returnedCoins
      }
      .store(in: &cancellables)
    
    // updates portfolioCoins
    $allCoins
      .combineLatest(portfolioDataService.$savedEntities)
      .map (mapAllCoinsToPortfolioCoins)
      .sink { [weak self] returnedCoins in
        guard let self = self else { return }
        self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: returnedCoins)
      }
      .store(in: &cancellables)
    
    // updates market data
    marketDataService.$marketData
      .combineLatest($portfolioCoins)
      .map(mapGlobalMarketData)
      .sink { [weak self] returendStats in
        self?.statistics = returendStats
        self?.isLoading = false
      }
      .store(in: &cancellables)
      
  }
  
  func updatePortfolio(coin: Coin, amount: Double) {
    portfolioDataService.updatePortfolio(coin: coin, amount: amount)
  }
  
  func reloadData() {
    isLoading = true
    coinDataService.getCoins()
    marketDataService.getData()
    HapticManager.notification(type: .success)
  }
  
  private func filterAndSortCoins(text: String, coins: [Coin], sort: SortOption) -> [Coin] {
    var filteredCoins = filterCoins(text: text, coins: coins)
    sortCoin(sort: sort, coins: &filteredCoins)
    return filteredCoins
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
  
  private func sortCoin(sort: SortOption, coins: inout [Coin]) {
    switch sort {
    case .rank, .holdings:
      coins.sort { $0.rank < $1.rank }
    case .rankReversed, .holdingsReversed:
      coins.sort { $0.rank > $1.rank }
//    case .holdings:
//      return coins.sorted { $0.currentHoldings > $1.currentHoldings }
//    case .holdingsReversed:
//      return coins.sorted { $0.currentHoldings > $1.currentHoldings }
    case .price:
      coins.sort { $0.currentPrice ?? 0 < $1.currentPrice ?? 0 }
    case .priceReversed:
      coins.sort { $0.currentPrice ?? 0 > $1.currentPrice ?? 0 }
    }
  }
  
  private func sortPortfolioCoinsIfNeeded(coins: [Coin]) -> [Coin] {
    // will only sort by holdings or revered
    switch sortOption {
    case .holdings:
      return coins.sorted(by: {$0.currentHoldingsValue > $1.currentHoldingsValue})
    case .holdingsReversed:
      return coins.sorted(by: {$0.currentHoldingsValue < $1.currentHoldingsValue})
    default:
      return coins
    }
  }
  
  private func mapAllCoinsToPortfolioCoins(allCoins: [Coin], portfolioEntities: [PortfolioEntity]) -> [Coin] {
    return allCoins.compactMap { coin -> Coin? in
      guard let entity = portfolioEntities.first(where: { $0.coinId == coin.id }) else { return nil }
      return coin.updateHoldings(amount: entity.amount)
    }
  }
  
  private func mapGlobalMarketData(marketDataModel: MarketData?, portfolioCoins: [Coin]) -> [StatisticModel] {
    var stats: [StatisticModel] = []
    guard let data = marketDataModel else { return stats }
    let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
    let volume = StatisticModel(title: "24h Volume", value: data.volume)
    let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
    
    let portfolioValue = portfolioCoins
      .map({ $0.currentHoldingsValue })
      .reduce(0, +)
    
    let previousValue = portfolioCoins
      .map { coin -> Double in
        let currentValue = coin.currentHoldingsValue
        let percentageChange = (coin.priceChangePercentage24H ?? 0) / 100
        let previousValue = currentValue / (1 + percentageChange)
        return previousValue
      }
      .reduce(0, +)
    
    let percentageChange = ((portfolioValue - previousValue) / previousValue) * 100
    
    let portfolio = StatisticModel(
      title: "Portfolio Value",
      value: portfolioValue.asCurrencyWith2Decimals(),
      percentageChange: percentageChange)
    
    stats.append(contentsOf: [
      marketCap,
      volume,
      btcDominance,
      portfolio
    ])
    return stats
  }
  
}
