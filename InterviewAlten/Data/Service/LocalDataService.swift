//
//  LocalDataService.swift
//  InterviewAlten
//
//  Created by Paweł Sobaszek on 03/03/2023.
//

import Foundation
import CoreData

protocol LocalDataServiceProtocol {
    var savedEntities: [DataEntity] { get }
    var savedEntitiesPublished: Published<[DataEntity]> { get }
    var savedEntitiesPublisher: Published<[DataEntity]>.Publisher { get }
    
    func add(dataModel: DataModel)
    func remove(id: String)
    func removeAll()
}

final class LocalDataService: LocalDataServiceProtocol {
    private let container: NSPersistentContainer
    private let containerName: String = "DataModelContainer"
    private let entityName: String = "DataEntity"
    
    @Published var savedEntities: [DataEntity] = []
    var savedEntitiesPublished: Published<[DataEntity]> { _savedEntities }
    var savedEntitiesPublisher: Published<[DataEntity]>.Publisher { $savedEntities }
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error {
                Log.e("Error loading Code Data! \(error)")
            }
            self.getDatas()
        }
    }
}

extension LocalDataService {
    func add(dataModel: DataModel) {
        let entity = DataEntity(context: container.viewContext)
        entity.id = dataModel.id
        entity.name = dataModel.name
        entity.desc = dataModel.description
        entity.price = dataModel.price
        entity.imageUrl = dataModel.imageUrl
        entity.timestamp = Date()
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
        let request = NSFetchRequest<DataEntity>(entityName: entityName)
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            Log.e("Error fetch Data Entities. \(error)")
        }
    }
    
    private func delete(entity: DataEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error while saving to \(containerName). \(error)")
        }
    }
    
    private func applyChanges() {
        save()
        getDatas()
    }
}
