//
//  CoreDataRepository.swift
//  AudioRecorder
//
//  Created by Ziqa on 10/09/25.
//

import Foundation
import CoreData

final class AudioEntityRepositoryImpl: AudioEntityRepository {
    
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func deleteRecording(recordings: [AudioEntity]) {
        for recording in recordings {
            context.delete(recording)
        }
        
        do {
            try context.save()
            print("Recording deleted")
        } catch {
            context.rollback()
        }
    }
    
    func addNewRecording(fileURL: URL, duration: Double) throws {
        let recording = AudioEntity(context: context)
        let count = getRecordingsCount()
        recording.uuid = UUID()
        recording.name = "New Recording \(count)"
        recording.createdAt = Date()
        recording.fileURL = fileURL.lastPathComponent
        recording.duration = duration
        
        do {
            try context.save()
            print("Recording saved")
        } catch {
            print("Failed saving audio \(error.localizedDescription)")
        }
    }
    
    func getAllRecordings() -> [AudioEntity] {
        let request = AudioEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \AudioEntity.createdAt, ascending: false)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch recordings: \(error.localizedDescription)")
            return []
        }
    }
    
    func getRecentRecording() -> [AudioEntity] {
        let request = AudioEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \AudioEntity.createdAt, ascending: false)]
        request.fetchLimit = 1
        
        do {
            return try context.fetch(request)
        } catch {
            return []
        }
    }
    
    func getRecordingsCount() -> Int {
        let request = AudioEntity.fetchRequest()
        do {
            let count = try context.count(for: request)
            return count
        } catch {
            print("Failed counting items")
            return 0
        }
    }
}
