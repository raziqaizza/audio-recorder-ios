//
//  RecordingScreen.swift
//  AudioRecorder
//
//  Created by Ziqa on 09/09/25.
//

import SwiftUI

struct RecordingsScreen: View {
    
    @FetchRequest(fetchRequest: AudioEntity.getAllRecordings(), animation: .snappy)
    private var allRecordings: FetchedResults<AudioEntity>
    
    @EnvironmentObject var router: Router
    @StateObject var viewModel: RecordingsViewModel
    
    init(factory: ViewModelFactory) {
        _viewModel = StateObject(wrappedValue: factory.makeRecordingsViewModel())
    }
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            ScrollView {
                LazyVStack(spacing: 0) {
                    recordingsList()
                }
                .padding(.bottom, viewModel.isEditing ? 0 : size.height * 0.2)
            }
        }
        .navigationTitle("All Recordings")
        .navigationBarBackButtonHidden()
        .toolbar(viewModel.isEditing ? .visible : .hidden, for: .bottomBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.isEditing.toggle()
                    viewModel.showSheet.toggle()
                    viewModel.expandedRecording = nil
                } label: {
                    Text(viewModel.isEditing ? "Done" : "Edit")
                }
                .disabled(viewModel.isRecording)
            }
            
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    router.popLast()
                    viewModel.showSheet = false
                } label: {
                    Image(systemName: "chevron.left")
                        .fontWeight(.semibold)
                }
                .disabled(viewModel.isRecording)
            }
            
            if viewModel.isEditing {
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Button {
                            // Share recording
                        } label: {
                            Image(systemName: "square.and.arrow.up")
                        }
                        
                        if !viewModel.selectedRecordingsId.isEmpty {
                            Text("\(viewModel.selectedRecordingsId.count) selected")
                                .frame(maxWidth: .infinity)
                        } else {
                            Spacer()
                        }
                        
                        Button {
                            withAnimation(.snappy) {
                                let recordingsToDelete = viewModel.recordings.filter {
                                    viewModel.selectedRecordingsId.contains($0.id)
                                }
                                viewModel.deleteRecording(for: recordingsToDelete)
                                viewModel.selectedRecordingsId.removeAll()
                            }
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $viewModel.showSheet) {
            HStack(spacing: 24) {
                if viewModel.isRecording {
                    VStack {
                        Text("New Recording \(viewModel.recordingNumber)")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Text(format(time: viewModel.recordingDuration))
                            .foregroundStyle(.secondary)
                        
//                        Rectangle()
//                            .frame(height: 40)
//                            .foregroundStyle(.red)
                    }
                    .transition(.move(edge: .leading).combined(with: .opacity))
                }
                
                RecordButtonView(isRecording: $viewModel.isRecording) {
                    viewModel.isRecording.toggle()
                    viewModel.getRecordingNumber()
                    if viewModel.isRecording {
                        viewModel.startRecording()
                    } else {
                        withAnimation(.snappy) {
                            viewModel.stopRecording()
                        }
                    }
                }
            }
            .interactiveDismissDisabled(!viewModel.isEditing)
            .presentationDetents([.fraction(0.2)])
            .presentationBackgroundInteraction(viewModel.isRecording ? .disabled : .enabled)
            .presentationBackground(.thinMaterial)
            .padding(.horizontal, 24)
        }
        .onAppear {
            viewModel.getAllRecordings()
            viewModel.setupRecording()
        }
        .environmentObject(viewModel)
        .animation(.easeInOut(duration: 0.3), value: [viewModel.isRecording, viewModel.isEditing])
    }
    
    @ViewBuilder
    private func recordingsList() -> some View {
        ForEach(viewModel.recordings, id: \.objectID) { recording in
            RecordingRowView(
                isExpanded: viewModel.expandedRecording == recording.id,
                recording: recording
            )
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.snappy) {
                    if viewModel.expandedRecording != recording.id {
                        viewModel.expandedRecording = recording.id
                    }
                }
            }
        }
    }
}

#Preview {
    let persistenceController = PersistenceController()
    let factory = ViewModelFactory(persistenceController: persistenceController)
    let viewModel = factory.makeRecordingsViewModel()
    NavigationStack {
        RecordingsScreen(factory: factory)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(Router())
            .environmentObject(viewModel)
    }
}


/*
 
 List(viewModel.recordings, selection: $viewModel.selectedRecordingsId) { recording in
     NavigationLink {
         PlayerScreen(recording: recording, viewModel: viewModel)
     } label: {
         Text(recording.name ?? "")
     }
 }
 .listStyle(.plain)
 .environmentObject(viewModel)
 .padding(.bottom, isEditing ? 0 : size.height * 0.2)
 
 */
