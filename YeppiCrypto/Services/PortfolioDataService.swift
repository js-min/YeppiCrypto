//
//  PortfolioDataService.swift
//  YeppiCrypto
//
//  Created by JISU MIN on 2022/06/19.
//

import Foundation
import CoreData

class PortfolioDataService {
  
  
  private let container : NSPersistentContainer
  private let containerName: String = "PortfolioContainer"
  private let entityName: String =  "PortfolioEntity"
  
  @Published var savedEntities: [PortfolioEntity] = []
  
  
  init() {
    container = NSPersistentContainer(name: containerName)
    container.loadPersistentStores { _, error in
      if let error = error {
        print("DEBUG: Error loading Core data! \(error)")
      }
      self.getPortfolio()
    }
  }
  
  // MARK: PUBLIC
  
  func updatePortfolio(coin: Coin, amount: Double) {
    
    // 이미 CoreData에 있는 Coin 이라면 -> update, 아니라면 create
    if let entity = savedEntities.first(where: { $0.coinId == coin.id }) {
      if amount > 0 {
        update(entity: entity, amount: amount)
      } else {
        delete(entity: entity)
      }
    } else {
      add(coin: coin, amount: amount)
    }
    
  }
  
  // MARK: PRIVATE
  
  private func getPortfolio() {
    let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
    do {
      savedEntities = try container.viewContext.fetch(request)
    } catch let error {
      print("DEBUG: Error fetching Portfolio Entities. \(error)")
    }
  }
  
  private func add(coin: Coin, amount: Double) {
    let entity = PortfolioEntity(context: container.viewContext)
    entity.coinId = coin.id
    entity.amount = amount
    applyChanges()
  }
  
  private func update(entity: PortfolioEntity, amount: Double) {
    entity.amount = amount
    applyChanges()
  }
  
  private func delete(entity: PortfolioEntity) {
    container.viewContext.delete(entity)
    applyChanges()
  }
  
  private func save() {
    do {
      try container.viewContext.save()
    } catch let error {
      print("DEBUG: Error saving to core data. \(error)")
    }
  }
  
  private func applyChanges() {
    save()
    getPortfolio()
  }
  
}
