//
//  NSManagedObjectContextExtensions.swift
//  InterviewAlten
//
//  Created by Paweł Sobaszek on 06/03/2023.
//

import CoreData

extension NSManagedObjectContext {
    func saveIfChanged(containerName: String) {
        guard hasChanges else { return }
        do {
            try save()
        } catch {
            Log.e("Error while saving to \(containerName). \(error)")
        }
    }
}
