//
//  Router.swift
//  AudioRecorder
//
//  Created by Ziqa on 09/09/25.
//

import SwiftUI

class Router: ObservableObject {
    
    // This class is to create custom navigation path
    // and functions to navigate
    
    @Published var paths = NavigationPath()
    
    func push(to screen: Routes) {
        paths.append(screen)
    }
    
    func popLast() {
        paths.removeLast()
    }
    
    func popToRoot() {
        paths.removeLast(paths.count)
    }
    
}
