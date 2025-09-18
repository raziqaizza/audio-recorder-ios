//
//  AudioRecorderService.swift
//  AudioRecorder
//
//  Created by Ziqa on 09/09/25.
//

import Foundation
import AVFoundation

class AudioRecorderService: NSObject, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    
    private var player: AVAudioPlayer?
    private var recorder: AVAudioRecorder?
    private let session = AVAudioSession.sharedInstance()
    private var settings: [String: Any] = [:]
    var onPlaybackFinished: (() -> Void)?
    
    // MARK: - Record
    
    func setupRecorder() throws {
        try session.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
        try session.setActive(true)
        
        settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
    }
    
    func startRecording(to fileURL: URL) throws {
        do {
            recorder = try AVAudioRecorder(url: fileURL, settings: settings)
            recorder?.delegate = self
            recorder?.record()
        } catch {
            print("Error Recording Audio: \(error.localizedDescription)")
        }
    }
    
    func stopRecording() {
        recorder?.stop()
        recorder = nil
        do {
            try session.setActive(false)
        } catch {
            print("Error")
        }
    }
    
    // MARK: - Playback
    
    func setupPlayback(_ fileURL: URL) throws {
        try session.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
        try session.setActive(true)
        
        do {
            player = nil
            player = try AVAudioPlayer(contentsOf: fileURL)
            player?.delegate = self
            player?.prepareToPlay()
        }
    }
    
    func starPlayback() {
        player?.play()
    }
    
    func pausePlayback() throws {
        player?.pause()
    }
    
    func stopPlayback() throws {
        player?.stop()
        player = nil
        
        do {
            try session.setActive(false)
        } catch {
            print("Error")
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        onPlaybackFinished?()
    }
    
    func seek(to time: TimeInterval) -> TimeInterval {
        player?.currentTime = time
        let currentTime = time
        return currentTime
    }
    
    func getCurrentTime() -> TimeInterval {
        guard let player = player else { return 0.0 }
        return player.currentTime
    }
}
