//
//  AudioEntityRepository.swift
//  AudioRecorder
//
//  Created by Ziqa on 10/09/25.
//

import Foundation

protocol AudioEntityRepository {
    func addNewRecording(fileURL: URL, duration: Double) throws
    func deleteRecording(recordings: [AudioEntity])
    func getAllRecordings() -> [AudioEntity]
    func getRecentRecording() -> [AudioEntity]
}
