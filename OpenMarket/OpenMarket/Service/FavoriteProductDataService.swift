//
//  FavoriteProductDataService.swift
//  OpenMarket
//
//  Created by song on 2022/12/29.
//

import Foundation
import CoreData

protocol FavoriteProductDataProtocol {
  var savedEntities: [ProductEntity] { get set }
  var savedEntitiesPublisher: Published<[ProductEntity]>.Publisher { get }
  func updateFavoriteProduct(id: Int)
}

final class FavoriteProductDataService: FavoriteProductDataProtocol {
  
  @Published var savedEntities: [ProductEntity] = []
  
  var savedEntitiesPublisher: Published<[ProductEntity]>.Publisher {
    return $savedEntities
  }
  
  private let container: NSPersistentContainer
  private let containerName: String = "FavoriteProductContainer"
  private let entityName: String = "ProductEntity"
  
  init() {
    container = NSPersistentContainer(name: containerName)
    container.loadPersistentStores { _, error in
      if let error = error {
        print("Error loading \(error)")
      }
      self.getPortfolio()
    }
  }
  
  func updateFavoriteProduct(id: Int) {
    if let entity = savedEntities.first(where: { $0.productId == id }) {
      delete(entity: entity)
    } else {
      add(id: id)
    }
  }
  
  private func getPortfolio() {
    let request = NSFetchRequest<ProductEntity>(entityName: entityName)
    
    do {
      savedEntities = try container.viewContext.fetch(request)
    } catch let error {
      print("Error fetching Entities \(error)")
    }
  }
  
  private func add(id: Int) {
    let entity = ProductEntity(context: container.viewContext)
    entity.productId = Int16(id)
    applyChanges()
  }
  
  private func delete(entity: ProductEntity) {
    container.viewContext.delete(entity)
    applyChanges()
  }
  
  
  private func save() {
    do {
      try container.viewContext.save()
    } catch let error {
      print("Error saving to Core Data. \(error)")
    }
  }
  
  private func applyChanges() {
    save()
    getPortfolio()
  }
}

