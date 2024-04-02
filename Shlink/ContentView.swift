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
                .sheet(isPresented: $isShowingAddSheet, content: {
                    /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Content@*/Text("Sheet Content")/*@END_MENU_TOKEN@*/
                })
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
