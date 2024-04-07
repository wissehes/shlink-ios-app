//
//  ShortUrlsOverview.swift
//  Shlink
//
//  Created by Wisse Hes on 26/03/2024.
//

import SwiftUI

struct ShortUrlsOverview: View {
    
    var vm: ShortUrlsViewModel
    
    @Binding var addItemSheetOpened: Bool
    
    @ViewBuilder
    var statistics: some View {
        ScrollView(.horizontal) {
            HStack {
                Button {
                    addItemSheetOpened.toggle()
                } label: {
                    VStack(alignment: .center, spacing: 5) {
                        Image(systemName: "plus.circle")
                            .foregroundStyle(.white)
                            .bold()
                            .font(.system(size: 20))
                        
                        Text("Add")
                            .foregroundStyle(.white)
                            .font(.system(size: 16))
                            .bold()
                    }
                    .frame(width: 80, height: 80)
                    .background(Color.accentColor)
                    .clipShape(.rect(cornerRadius: 10))
                }
                    
                
                if let visits = vm.visits {
                    ListScrollItem(
                        title: "Visits",
                        content: Text(visits.visitsCount, format: .number)
                    )
                    
                    ListScrollItem(
                        title: "Orphan visits",
                        content: Text(visits.orphanVisitsCount, format: .number)
                    )
                    
                }
                
                if let items = vm.items {
                    ListScrollItem(title: "Short URLs", content: Text(items.count, format: .number))
                }
            }
        }
    }
    
    var body: some View {
        Group {
            if vm.isLoading {
                ProgressView("Loading...")
            } else if let items = vm.items {
                List {
                    
                    Section("Stats") {
                        statistics
                            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                            .listRowSeparator(.hidden)
                    }.listRowBackground(Color.clear)
                    
                    Section("Links") {
                        ForEach(items, id: \.shortCode) { item in
                            NavigationLink(value: item) {
                                ShortUrlItem(item: item, vm: vm)
                            }
                        }
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
                    Text(item.longURL?.absoluteString ?? "")
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

struct ListScrollItem: View {
    
    var title: String
    var content: Text
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text(title)
                .font(.system(size: 16))
                .bold()
                .textCase(.uppercase)
                .foregroundStyle(.secondary)
            
            content
                .font(.title2)
                .fontDesign(.rounded)
                .bold()
        }.padding()
            .frame(height: 80)
            .frame(minWidth: 80)
            .background(.background)
            .clipShape(.rect(cornerRadius: 10))
    }
}

#Preview {
    let container = DataController.previewContainer
    
    return ShortUrlsOverview(vm: .init(server: .previewServer()), addItemSheetOpened: .constant(false))
        .modelContainer(container)
        .listStyle(.sidebar)
}
