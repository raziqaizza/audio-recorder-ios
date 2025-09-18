//
//  ViewModelFactory.swift
//  AudioRecorder
//
//  Created by Ziqa on 10/09/25.
//

import Foundation
import CoreData

final class ViewModelFactory {
    private let audioService: AudioRecorderService
    private let repository: AudioEntityRepositoryImpl
    
    init(persistenceController: PersistenceController) {
        self.audioService = AudioRecorderService()
        self.repository = AudioEntityRepositoryImpl(context: persistenceController.container.viewContext)
    }
    
    func makeRecordingsViewModel() -> RecordingsViewModel {
        RecordingsViewModel(audioService: audioService, repository: repository)
    }
}
