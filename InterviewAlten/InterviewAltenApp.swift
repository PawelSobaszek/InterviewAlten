//
//  InterviewAltenApp.swift
//  InterviewAlten
//
//  Created by Paweł Sobaszek on 01/03/2023.
//

import SwiftUI

@main
struct InterviewAltenApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
