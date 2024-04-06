//
//  ContentView.swift
//  Shlink
//
//  Created by Wisse Hes on 24/03/2024.
//

import SwiftUI

struct ContentView: View {
    
    @State private var vm = ShortUrlsViewModel()
    
    @State private var isShowingAddSheet = false
    
    var body: some View {
        NavigationStack {
            ShortUrlsOverview(vm: vm)
                .navigationTitle("Short URLs")
                .toolbar { self.toolbar }
                .sheet(isPresented: $isShowingAddSheet) {
                    CreateShortUrlView(vm: vm)
                }
        }
    }
    
    var toolbar: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            Button("Add short URL", systemImage: "plus.circle") {
                isShowingAddSheet.toggle()
            }
        }
    }
}

#Preview {
    ContentView()
}
