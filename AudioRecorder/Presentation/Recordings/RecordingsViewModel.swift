//
//  RecordingsViewModel.swift
//  AudioRecorder
//
//  Created by Ziqa on 10/09/25.
//

import SwiftUI

final class RecordingsViewModel: ObservableObject {
    
    /// Recording screen properties
    @Published var isRecording = false
    @Published var isPlayingAudio = false
    @Published var showSheet = true
    @Published var recordings: [AudioEntity] = []
    @Published var selectedRecordingsId: Set<AudioEntity.ID> = []
    @Published var expandedRecording: AudioEntity.ID? = nil
    @Published var recordingDuration: TimeInterval = 0
    @Published var recordingNumber: Int = 0
    
    /// Recording row properties
    @Published var isEditing = false
    @Published var currentTime: TimeInterval = 0
    
    private var url: URL? = nil
    private var timer: Timer?
    private var audioService: AudioRecorderService
    private var repository: AudioEntityRepositoryImpl
    
    init(audioService: AudioRecorderService, repository: AudioEntityRepositoryImpl) {
        self.audioService = audioService
        self.repository = repository
        
        /// Callback if audio is finished playing
        audioService.onPlaybackFinished = { [weak self] in
            self?.isPlayingAudio = false
        }
    }
    
    // MARK: - Record
    
    func setupRecording() {
        do {
            try audioService.setupRecorder()
        } catch {
            print("Setup recorder failed: \(error)")
        }
    }
    
    func startRecording() {
        let count = recordings.count
        let fileName = "New_Recording_\(count).m4a"
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentPath.appendingPathComponent(fileName)
        recordingDuration = 0
        isRecording = true

        do {
            try audioService.startRecording(to: fileURL)
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
                self?.recordingDuration += 1
            }
        } catch {
            print("Recording failed: \(error.localizedDescription)")
        }
        
        url = fileURL
    }
    
    func stopRecording() {
        isRecording = false
        audioService.stopRecording()
        timer?.invalidate()
        timer = nil
        
        do {
            try repository.addNewRecording(fileURL: url!, duration: recordingDuration)
        } catch {
            print("Error Saving Recording: \(error)")
        }
        
        getRecentRecording()
    }
    
    func getAllRecordings() {
        let fetch = repository.getAllRecordings()
        recordings = fetch
    }
    
    func getRecentRecording() {
        let fetch = repository.getRecentRecording()
        recordings.insert(contentsOf: fetch, at: 0)
    }
    
    func deleteRecording(for recordings: [AudioEntity]) {
        repository.deleteRecording(recordings: recordings)
        
        self.recordings.removeAll { rec in
            recordings.contains(where: { $0.objectID == rec.objectID })
        }
    }
    
    func getRecordingNumber() {
        let count = repository.getRecordingsCount()
        recordingNumber = count + 1
    }
    
    // MARK: - Playback
    
    func setupPlayback(for recording: AudioEntity) {
        let fileName = recording.fileURL!
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let restoredURL = documentsURL.appendingPathComponent(fileName)
        
        do {
            try audioService.setupPlayback(restoredURL)
        } catch {
            print("Error setting up player: \(error.localizedDescription)")
        }
    }
    
    func startPlayback() {
        isPlayingAudio = true
        audioService.starPlayback()
    }
    
    func stopPlayback() {
        isPlayingAudio = false
        do {
            try audioService.stopPlayback()
        } catch {
            print("Error")
        }
    }
    
    func pausePlayback() {
        isPlayingAudio = false
        
        do {
            try audioService.pausePlayback()
        } catch {
            print("Error")
        }
    }
    
    func seek(to time: TimeInterval) {
        let seek = audioService.seek(to: time)
        currentTime = seek
    }
    
    func updateProgress() {
        currentTime = audioService.getCurrentTime()
    }
    
    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
//            guard let self = self else { return }
            self?.currentTime = self?.audioService.getCurrentTime() ?? 0
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func pauseTimer() {
    }
    
}
