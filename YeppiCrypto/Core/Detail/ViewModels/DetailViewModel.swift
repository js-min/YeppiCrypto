//
//  DetailViewModel.swift
//  YeppiCrypto
//
//  Created by JISU MIN on 2022/06/21.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
  
  @Published var overviewStatistics: [StatisticModel] = []
  @Published var additionalStatistics: [StatisticModel] = []
  
  private let coinDetailService: CoinDetailDataService
  
  private var cancellables = Set<AnyCancellable>()
  @Published var coin: Coin
  
  init(coin: Coin) {
    self.coin = coin
    self.coinDetailService = CoinDetailDataService(coin: coin)
    addSubscriber()
  }
  
  private func addSubscriber() {
    coinDetailService.$coinDetail
      .combineLatest($coin)
      .map(mapStats)
      .sink { [weak self] returnedArray in
        self?.overviewStatistics = returnedArray.overview
        self?.additionalStatistics = returnedArray.additional
      }
      .store(in: &cancellables)
  }
  
  private func mapStats(coinDetailModel: CoinDetail?, coinModel: Coin) -> (overview: [StatisticModel], additional: [StatisticModel]){
    return (
      createOverviewArray(coinModel: coinModel),
      createAdditionalArray(coinDetailModel: coinDetailModel, coinModel: coinModel))
  }
  
  func createOverviewArray(coinModel: Coin) -> [StatisticModel] {
    let price = (coinModel.currentPrice ?? 0).asCurrencyWith6Decimals()
    let pricePercentageChange = coinModel.priceChangePercentage24H
    let priceStat = StatisticModel(title: "Current Price", value: price, percentageChange: pricePercentageChange)
    
    let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
    let marketCapChange = coinModel.marketCapChangePercentage24H
    let marketCapStat = StatisticModel(title: "Market Capitalization", value: marketCap, percentageChange: marketCapChange)
    
    let rank = "\(coinModel.rank)"
    let rankStat = StatisticModel(title: "Rank", value: rank)
    
    let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
    let volumeStat = StatisticModel(title: "Volume", value: volume)
    return [
      priceStat, marketCapStat, rankStat, volumeStat
    ]
  }
  
  func createAdditionalArray(coinDetailModel: CoinDetail?, coinModel: Coin) -> [StatisticModel] {
    let high = coinModel.high24H?.asCurrencyWith6Decimals() ?? "n/a"
    let highStat = StatisticModel(title: "24h High", value: high)
    
    let low = coinModel.low24H?.asCurrencyWith6Decimals() ?? "n/a"
    let lowStat = StatisticModel(title: "24h Low", value: low)
    
    let priceChange = coinModel.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
    let pricePercentChange2 = coinModel.priceChangePercentage24H
    let priceChangeStat = StatisticModel(title: "24h Price Change", value: priceChange, percentageChange: pricePercentChange2)
    
    let marketCapChange2 = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
    let marketCapPercentChange = coinModel.marketCapChangePercentage24H
    let marketCapChangeStat = StatisticModel(title: "24h Market Cap Change", value: marketCapChange2, percentageChange: marketCapPercentChange)
    
    let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
    let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
    let blockTimeStat = StatisticModel(title: "Block Time", value: blockTimeString)
    
    let hashing = coinDetailModel?.hashingAlgorithm ?? "n/a"
    let hashingStat = StatisticModel(title: "Hashing Algorithm", value: hashing)
    
    return [
      highStat, lowStat, priceChangeStat, marketCapChangeStat, blockTimeStat, hashingStat
    ]
  }
}
