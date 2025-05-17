//
//  sutainableFashionApp.swift
//  sutainableFashion
//
//  Created by 최승희 on 5/17/25.
//

import SwiftUI

@main
struct sutainableFashionApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
