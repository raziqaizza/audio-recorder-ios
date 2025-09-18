//
//  AudioRecorderApp.swift
//  AudioRecorder
//
//  Created by Ziqa on 09/09/25.
//

import SwiftUI

@main
struct AudioRecorderApp: App {
    
    @StateObject private var router = Router()
    
    let persistenceController = PersistenceController()
    let factory: ViewModelFactory
    
    init() {
        self.factory = ViewModelFactory(persistenceController: persistenceController)
    }
    
    var body: some Scene {
        WindowGroup {
            MyAudiosScreen(factory: factory)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(router)
        }
    }
}
