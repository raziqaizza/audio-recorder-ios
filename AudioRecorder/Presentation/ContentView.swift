//
//  ContentView.swift
//  AudioRecorder
//
//  Created by Ziqa on 09/09/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var dummyItems = ["Voice 1", "Voice 2", "Voice 3"]
    @State private var isEditing: Bool = false
    @State private var isRecording: Bool = false
    
    @EnvironmentObject var router: Router
    
    var body: some View {
        ZStack(alignment: .bottom) {
            List {
                ForEach(0..<20, id: \.self) { i in
                    HStack {
                        Text("Audio \(i)")
                    }
                    .padding(.vertical, 8)
                }
            }
            .listStyle(.plain)
            
            if isRecording {
                Rectangle()
                    .foregroundStyle(.gray.opacity(0.14))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            RecordButtonView(isRecording: $isRecording) {
                isRecording.toggle()
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .navigationTitle("All Recordings")
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isEditing.toggle()
                } label: {
                    Text(isEditing ? "Done" : "Edit")
                }
                .disabled(isRecording)
            }
            
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    router.popLast()
                } label: {
                    Image(systemName: "chevron.left")
                        .fontWeight(.semibold)
                }
                .disabled(isRecording)
            }
            
            if isEditing {
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Button {
                            // Share audio
                        } label: {
                            Image(systemName: "square.and.arrow.up")
                        }
                        
                        Spacer()
                        
                        Button {
                            // Share audio
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                }
            }
        }
        .toolbar(isEditing ? .visible : .hidden, for: .bottomBar)
        .animation(.snappy, value: isEditing)
    }
}

struct SheetView: View {
    @Binding var showingOverlay: Bool

    var body: some View {
        VStack {
            Text("This is the Sheet Content")
                .font(.title)
                .padding()

            Button("Show Overlay from Sheet") {
                showingOverlay = true
            }
            .buttonStyle(.bordered)
        }
    }
}

#Preview {
    ContentView()
}
