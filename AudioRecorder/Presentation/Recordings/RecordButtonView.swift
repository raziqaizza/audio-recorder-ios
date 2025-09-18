//
//  RecordButtonView.swift
//  AudioRecorder
//
//  Created by Ziqa on 09/09/25.
//

import SwiftUI

struct RecordButtonView: View {
    
    @Binding var isRecording: Bool
    @State private var buttonCircle: CGFloat = 60
    @State private var buttonSquare: CGFloat = 30
    
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .stroke(Color.gray, lineWidth: 5)
                    .frame(width: 75, height: 75)
                
                RoundedRectangle(cornerRadius: isRecording ? 5 : 50)
                    .foregroundStyle(.red)
                    .frame(
                        maxWidth: isRecording ? buttonSquare : buttonCircle,
                        maxHeight: isRecording ? buttonSquare : buttonCircle)
            }
            .onTapGesture {
                action()
            }
        }
        .padding(.vertical, 20)
        .animation(.snappy, value: isRecording)
    }
}

#Preview {
    @Previewable @State var isRecording: Bool = true
    RecordButtonView(isRecording: $isRecording) {
        isRecording.toggle()
    }
}
