//
//  ContentView.swift
//  AudioRecorder
//
//  Created by Ziqa on 09/09/25.
//

import SwiftUI

struct MyAudiosScreen: View {
    
    @EnvironmentObject var router: Router
    
    let factory: ViewModelFactory
    
    var body: some View {
        NavigationStack(path: $router.paths) {
            VStack {
                List {
                    NavigationLink(value: Routes.Recordings) {
                        HStack(spacing: 16) {
                            Image(systemName: "waveform")
                                .font(.title3)
                                .foregroundStyle(.blue)
                            
                            Text("All Recordings")
                            
                            Spacer()
                            
//                            Text("\(allRecordings.count)")
//                                .font(.title3)
//                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    NavigationLink(value: Routes.RecentlyDeleted) {
                        HStack(spacing: 16) {
                            Image(systemName: "trash")
                                .font(.title3)
                                .foregroundStyle(.blue)
                            
                            Text("Recently Deleted")
                            
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("My Audios")
            .navigationDestination(for: Routes.self) { route in
                route.destination(factory: factory)
            }
        }
    }
}

#Preview {
    let persistenceController = PersistenceController()
    let factory = ViewModelFactory(persistenceController: persistenceController)
    MyAudiosScreen(factory: factory)
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(Router())
}
