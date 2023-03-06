//
//  LocalDataService.swift
//  InterviewAlten
//
//  Created by Paweł Sobaszek on 03/03/2023.
//

import Foundation
import CoreData

protocol LocalDataServiceProtocol {
    func getAll() -> [DataEntity]
    func add(dataModel: DataModel)
    func remove(id: String)
    func removeAll()
}

final class LocalDataService: LocalDataServiceProtocol {
    private let container: NSPersistentContainer
    
    private var savedEntities: [DataEntity] = []

    init() {
        container = NSPersistentContainer(name: LocalDataConstants.containerName)
        container.loadPersistentStores { _, error in
            if let error {
                Log.e("Error loading Code Data! \(error)")
            }
        }
    }
}

extension LocalDataService {
    func getAll() -> [DataEntity] {
        getDatas()
        removeOverdueDatas()
        return savedEntities
    }
    
    func add(dataModel: DataModel) {
        let entity = DataEntity(context: container.viewContext)
        entity.id = dataModel.id
        entity.name = dataModel.name
        entity.desc = dataModel.description
        entity.price = dataModel.price
        entity.imageUrl = dataModel.imageUrl
        applyChanges()
    }
    
    func remove(id: String) {
        if let entity = savedEntities.first(where: { $0.id == id }) {
            delete(entity: entity)
        }
    }
    
    func removeAll() {
        savedEntities.forEach { entity in
            delete(entity: entity)
        }
    }
}

extension LocalDataService {
    private func getDatas() {
        let request = NSFetchRequest<DataEntity>(entityName: LocalDataConstants.entityName)
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            Log.e("Error while fetching Data Entities. \(error)")
        }
    }
    
    private func removeOverdueDatas() {
        let currentDateTimeInterval = Date().timeIntervalSince1970
        Log.i("Data before deleting expired ones: \(savedEntities)")
        savedEntities.forEach { dataEntity in
            if let entityTimestamp = dataEntity.timestamp, let entityID = dataEntity.id {
                if (currentDateTimeInterval - entityTimestamp.timeIntervalSince1970 > LocalDataConstants.cacheOverdueInSeconds) {
                    Log.i("DataEntity with ID = \(entityID) is overdue.")
                    remove(id: entityID)
                }
            }
        }
        Log.i("Data after deleting expired ones: \(savedEntities)")
    }
    
    private func delete(entity: DataEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func applyChanges() {
        container.viewContext.saveIfChanged(containerName: LocalDataConstants.containerName)
        getDatas()
    }
}
