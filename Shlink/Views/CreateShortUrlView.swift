//
//  CreateShortUrlView.swift
//  Shlink
//
//  Created by Wisse Hes on 27/03/2024.
//

import SwiftUI

struct CreateShortUrlView: View {
    var vm: ShortUrlsViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var nameInput = ""
    @State private var customSlugInput = ""
    @State private var urlInput = ""
    @State private var tags = ""
    
    @State private var forwardQuery: Bool = true
    @State private var isCrawlable: Bool = false
    
    
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack {
            Form {
                
                Section("Main") {
                    HStack {
                        Label("URL to be shortened", systemImage: "link")
                            .labelStyle(.iconOnly)
                        
                        TextField("URL to be shortened", text: $urlInput)
                            .keyboardType(.URL)
                            .textInputAutocapitalization(.never)
                    }
                    
                    HStack {
                        Label("Tags", systemImage: "tag")
                            .labelStyle(.iconOnly)
                        
                        TextField("Tags", text: $tags)
                            .textInputAutocapitalization(.never)
                    }
                }
                
                Section("Details") {
                    TextField("Custom slug (optional)", text: $customSlugInput)
                        .textInputAutocapitalization(.never)
                }
                
                Section("Other behaviours") {
                    Toggle("Forward query on redirect", isOn: $forwardQuery)
                    Toggle("Make it crawlable", isOn: $isCrawlable)
                }
                
                
            }.navigationTitle("Create short URL")
                .toolbar { self.toolbar }
        }
    }
    
    @ToolbarContentBuilder
    var toolbar: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            Button("Save") {
                Task { await save() }
            }
        }
        
        ToolbarItem(placement: .cancellationAction) {
            Button("Cancel", role: .cancel) {
                dismiss()
            }
        }
    }
    
    func save() async {
        isLoading = true
        defer { isLoading = false }
        
        var payload = CreateShortURLPayload(longUrl: self.urlInput)
        
        if !self.customSlugInput.isEmpty {
            payload.customSlug = self.customSlugInput
        }
        
        if !self.tags.isEmpty {
            let tags = self.tags.split(separator: ", ").map(String.init)
            payload.tags = tags
        }
        
        do {
            try await vm.createShortUrl(data: payload)
        } catch {
            debugPrint(error)
        }
        
        dismiss()
    }
}

#Preview {
    @State var isOpen = true
    let container = DataController.previewContainer
    let server = Server.previewServer()
    
    return VStack {
        Button("open") { isOpen.toggle() }
    }.sheet(isPresented: $isOpen) {
        CreateShortUrlView(vm: .init(server: server))
    }.modelContainer(container)
}
