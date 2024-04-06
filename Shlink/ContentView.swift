//
//  ContentView.swift
//  Shlink
//
//  Created by Wisse Hes on 24/03/2024.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationStack {
            ServersOverview()
        }
    }
    
}

#Preview {
    let container = DataController.previewContainer
    
    return ContentView()
        .modelContainer(container)
        
}
