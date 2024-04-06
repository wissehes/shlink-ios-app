//
//  ShortUrlsOverview.swift
//  Shlink
//
//  Created by Wisse Hes on 26/03/2024.
//

import SwiftUI

struct ShortUrlsOverview: View {
    
    var vm: ShortUrlsViewModel
    
    var body: some View {
        Group {
            if vm.isLoading {
                ProgressView("Loading...")
            } else if let items = vm.items {
                List {
                    ForEach(items, id: \.shortCode) { item in
                        ShortUrlItem(item: item, vm: vm)
                    }
                }
            } else {
                ContentUnavailableView(
                    "No short URLs",
                    systemImage: "link",
                    description: Text(vm.error?.localizedDescription ?? "Somewthing went wrong.")
                )
            }
        }.task { await vm.fetch() }
            .refreshable { await vm.fetch() }
    }
}

extension ShortUrlsOverview {
    struct ShortUrlItem: View {
        var item: ShlinkAPI.ShortURL
        var vm: ShortUrlsViewModel
        
        @State private var deleteConfirmationShowing = false
        
        private func delete() {
            withAnimation {
                vm.items = vm.items?.filter { $0.shortCode != item.shortCode }
            }
            
            Task {
                let _ = try? await vm.server.api.deleteShortUrl(item: item)
                await vm.fetch()
            }
        }
        
        var body: some View {
            HStack {
                VStack(alignment: .leading) {
                    Text(item.title ?? item.shortCode)
                        .lineLimit(1)
                        .bold()
                    Text(item.longURL)
                        .lineLimit(1)
                }
                
                Spacer()
                
                Text("**\(item.visitsCount, format: .number)**\n visits")
                    .multilineTextAlignment(.center)
            }.swipeActions {
                Button("Delete", systemImage: "trash") {
                    deleteConfirmationShowing = true
                }.tint(.red)
            }
            .confirmationDialog(
                "Are you sure you want to delete this short URL?",
                isPresented: $deleteConfirmationShowing
            ) {
                Button("Delete", role: .destructive) { delete() }
            }
        }
        
    }
}

#Preview {
    let container = DataController.previewContainer
    
    return ShortUrlsOverview(vm: .init(server: .previewServer()))
        .modelContainer(container)
}
