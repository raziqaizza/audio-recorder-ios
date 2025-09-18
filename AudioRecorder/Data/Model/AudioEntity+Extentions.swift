//
//  AudioEntity+Extentions.swift
//  AudioRecorder
//
//  Created by Ziqa on 10/09/25.
//

import Foundation
import CoreData

extension AudioEntity {
    
    static func getAllRecordings() -> NSFetchRequest<AudioEntity> {
        let request = AudioEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \AudioEntity.createdAt, ascending: true)]
        return request
    }
    
    static var sampleAudio: AudioEntity {
        let context = PersistenceController.preview.container.viewContext
        let sample = AudioEntity(context: context)
        let fileName = "Sample_Recording_1"
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentPath.appendingPathComponent(fileName + ".m4a")
        
        sample.uuid = UUID()
        sample.name = fileName
        sample.createdAt = Date()
        sample.duration = 5
        sample.fileURL = fileURL.lastPathComponent
        return sample
    }
    
}
