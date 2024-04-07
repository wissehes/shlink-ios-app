//
//  HomeView.swift
//  Shlink
//
//  Created by Wisse Hes on 06/04/2024.
//

import SwiftUI

struct HomeView: View {
    var server: Server
    
    init(server: Server) {
        self._vm = .init(initialValue: ShortUrlsViewModel(server: server))
        self.server = server
    }
    
    @State private var vm: ShortUrlsViewModel
    @State private var isShowingAddSheet = false
    
    var body: some View {
            ShortUrlsOverview(vm: vm, addItemSheetOpened: $isShowingAddSheet)
                .navigationTitle("Short URLs")
                .toolbar { self.toolbar }
                .sheet(isPresented: $isShowingAddSheet) {
                    CreateShortUrlView(vm: vm)
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
    let container = DataController.previewContainer
    let server = Server.previewServer()
    
    return HomeView(server: server)
        .modelContainer(container)
}
