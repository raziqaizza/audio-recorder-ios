//
//  View+Extentions.swift
//  AudioRecorder
//
//  Created by Ziqa on 16/09/25.
//

import Foundation
import SwiftUI

extension View {
    
    /// Format date into string, use "dd MMM yyy" for the "format" value
    func format(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    /// Format time into string to have minutes and seconds
    func format(time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    /// Custom horizontal alignment, use as a modifier to a UI component
    @ViewBuilder
    func hSpacing(_ alignment: Alignment = .center) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }
    
    /// Custom vertical alignment, use as a modifier to a UI component
    @ViewBuilder
    func vSpacing(_ alignment: Alignment = .center) -> some View {
        self
            .frame(maxHeight: .infinity, alignment: alignment)
    }
    
}
