//
//  ServersOverview.swift
//  Shlink
//
//  Created by Wisse Hes on 06/04/2024.
//

import SwiftUI
import SwiftData

/// Overview for all added servers
struct ServersOverview: View {
    
    @Binding var selectedServer: Server?
    @Query var servers: [Server]
    
    @State var showingAddServerSheet = false
    
    var body: some View {
        List(servers, selection: $selectedServer) { server in
            NavigationLink(value: server) {
                itemView(server)
            }
        }
            .navigationTitle("Servers")
            .sheet(isPresented: $showingAddServerSheet, content: AddServerView.init)
            .toolbar {
                Button("Add server", systemImage: "plus.circle") {
                    showingAddServerSheet.toggle()
                }
            }
//            .navigationDestination(for: Server.self) { server in
//                HomeView.init(server: server)
//            }
        
    }
    
    func itemView(_ server: Server) -> some View {
        VStack(alignment: .leading) {
            Text(server.name)
                .bold()
            Text(server.url)
        }
    }
}

#Preview {
    let container = DataController.previewContainer
    
    return NavigationStack {
        ServersOverview(selectedServer: .constant(nil))
    }.modelContainer(container)
}
