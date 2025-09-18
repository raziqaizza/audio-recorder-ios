//
//  PersistenceController.swift
//  AudioRecorder
//
//  Created by Ziqa on 09/09/25.
//

import Foundation
import CoreData

class PersistenceController {
    
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        self.container = NSPersistentContainer(name: "AudioRecorder")
        
        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("Failed to retrieve a persistent store description.")
        }
        
        // Enable automatic lightweight migration
        description.shouldMigrateStoreAutomatically = true
        description.shouldInferMappingModelAutomatically = true
        
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error Core Data: \(error.localizedDescription)")
            }
        }
    }
    
    func save() {
        let context = container.viewContext
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            print("Error Saving Data: \(error.localizedDescription)")
        }
    }
    
    static var preview: PersistenceController = {
        let persistence = PersistenceController(inMemory: true)
        let context = persistence.container.viewContext
        
//        for i in 0..<3 {
//            let fileName = "New_Recording_\(i)"
//            let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//            let fileURL = documentPath.appendingPathComponent(fileName + ".m4a")
//            
//            let audio = AudioEntity(context: context)
//            audio.uuid = UUID()
//            audio.name = fileName
//            audio.duration = 22
//            audio.createdAt = Date()
//            audio.fileURL = fileURL.lastPathComponent
//        }
        
        return persistence
    }()
}
