//
//  ContentView.swift
//  Shlink
//
//  Created by Wisse Hes on 24/03/2024.
//

import SwiftUI
import SwiftData
struct ContentView: View {
    
    @State private var selectedServer: Server?
    @Query private var servers: [Server]
    
    var body: some View {
        NavigationSplitView {
            ServersOverview(selectedServer: $selectedServer)
        } content: {
            Group {
                if let selectedServer {
                    HomeView(server: selectedServer)
                        .listStyle(.insetGrouped)
                        .navigationDestination(for: ShlinkAPI.ShortURL.self) { link in
                            ShortURLDetailView(item: link)
                                .environment(selectedServer)
                        }
                } else {
                    Text("Pick a server")
                }
            }
        } detail: {
            Text("Hi!")
        }.onAppear {
            // Select the first server in the list on appear
            guard
                selectedServer == nil,
                let firstServer = servers.first
            else { return }
            
            self.selectedServer = firstServer
        }
    }
    
}

#Preview {
    let container = DataController.previewContainer
    
    return ContentView()
        .modelContainer(container)
    
}
