//
//  ContentView.swift
//  Shlink
//
//  Created by Wisse Hes on 24/03/2024.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedServer: Server?
    
    var body: some View {
        NavigationSplitView {
            ServersOverview(selectedServer: $selectedServer)
        } detail: {
            if let selectedServer {
                HomeView(server: selectedServer)
            } else {
                Text("Pick a server")
            }
        }
    }
    
}

#Preview {
    let container = DataController.previewContainer
    
    return ContentView()
        .modelContainer(container)
        
}
