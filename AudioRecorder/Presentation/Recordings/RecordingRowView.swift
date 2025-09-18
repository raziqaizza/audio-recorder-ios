//
//  ItemRowView.swift
//  AudioRecorder
//
//  Created by Ziqa on 09/09/25.
//

import SwiftUI

struct RecordingRowView: View {
    
    @EnvironmentObject var viewModel: RecordingsViewModel
    @State private var isSelected: Bool = false
    @State private var isPlaying: Bool = false
    
    var isExpanded: Bool
    let recording: AudioEntity
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(alignment: .center, spacing: 16) {
                if viewModel.isEditing {
                    Button {
                        if isSelected {
                            viewModel.selectedRecordingsId.remove(recording.id)
                        } else {
                            viewModel.selectedRecordingsId.insert(recording.id)
                        }
                        isSelected.toggle()
                    } label: {
                        Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                            .font(.title3)
                    }
                    .transition(.move(edge: .leading).combined(with: .opacity))
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(recording.name ?? "")
                        .fontWeight(.semibold)
                    
                    Text(format(date: recording.createdAt ?? Date(), format: "dd MMM yyy"))
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                if !isExpanded {
                    Text(format(time: recording.duration))
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .vSpacing(.bottom)
                        .transition(.push(from: .trailing).combined(with: .blurReplace))
                }
            }
            
            if isExpanded {
                Group {
                    Slider(value: $viewModel.currentTime, in: 0...recording.duration) { editing in
                        if !editing {
                            viewModel.seek(to: viewModel.currentTime)
                        }
                    }
                    
                    HStack {
                        Text(format(time: viewModel.currentTime))
                        Spacer()
                        Text(format(time: recording.duration))
                    }
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    
                    HStack(alignment: .center, spacing: 36) {
                        Button {
                            // Rewind 15 seconds
                        } label: {
                            Image(systemName: "15.arrow.trianglehead.counterclockwise")
                                .font(.title2)
                        }
                        
                        Button {
                            if viewModel.isPlayingAudio {
                                viewModel.isPlayingAudio.toggle()
                                viewModel.pausePlayback()
                                print("pause playback")
                            } else {
                                viewModel.isPlayingAudio.toggle()
                                viewModel.startPlayback()
                                print("start playback")
                            }
                        } label: {
                            Image(systemName: viewModel.isPlayingAudio ? "pause.fill" : "play.fill")
                                .font(.largeTitle)
                        }
                        .frame(maxWidth: 40, maxHeight: 40)
                        
                        Button {
                            // Fast forward 15 seconds
                        } label: {
                            Image(systemName: "15.arrow.trianglehead.clockwise")
                                .font(.title2)
                        }
                    }
                    .foregroundStyle(.primary)
                }
                .transition(.move(edge: .top).combined(with: .blurReplace))
                .onAppear {
                    viewModel.setupPlayback(for: recording)
                }
            }
            
            Divider()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .animation(.snappy(duration: 0.3), value: [ isExpanded])
        .onReceive(Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()) { _ in
            viewModel.updateProgress()
        }
    }
}

#Preview {
    let persistenceController = PersistenceController()
    let factory = ViewModelFactory(persistenceController: persistenceController)
    let viewModel = factory.makeRecordingsViewModel()
    let sampleAudio = AudioEntity.sampleAudio
    
    ScrollView {
        RecordingRowView(isExpanded: true, recording: sampleAudio)
        RecordingRowView(isExpanded: false, recording: sampleAudio)
    }
    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    .environmentObject(viewModel)
}
