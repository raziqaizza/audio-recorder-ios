//
//  Routes.swift
//  AudioRecorder
//
//  Created by Ziqa on 09/09/25.
//

// This enum class is to lay out the navigations
// that are available in the project

import SwiftUI

enum Routes: Hashable {
    case MyAudio
    case Recordings
    case RecentlyDeleted
    
    @ViewBuilder
    func destination(factory: ViewModelFactory) -> some View {
        switch self {
        case .MyAudio:
            MyAudiosScreen(factory: factory)
        case .Recordings:
            RecordingsScreen(factory: factory)
        case .RecentlyDeleted:
            RecentlyDeletedScreen()
        }
    }
}
