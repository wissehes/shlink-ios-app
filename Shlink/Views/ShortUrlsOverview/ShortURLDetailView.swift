//
//  ShortURLDetailView.swift
//  Shlink
//
//  Created by Wisse Hes on 06/04/2024.
//

import SwiftUI

struct ShortURLDetailView: View {
    var item: ShlinkAPI.ShortURL
    
    @Environment(\.dismiss) private var dismiss
    @Environment(Server.self) var server
    
    @State private var showingDeleteConfirmation = false
    @State private var showingQRCodeOverlay = false
    
    @State private var showingFullLongUrl = false
    
    private var actions: some View {
        ScrollView(.horizontal) {
            HStack {
                // Share action
                if let url = item.shortURL {
                    ShareLink("Share", item: url)
                }
                
                // View QR Code
                Button("Get QR Code", systemImage: "qrcode") {
                    showingQRCodeOverlay = true
                }
                .popover(isPresented: $showingQRCodeOverlay) {
                    AsyncImage(url: item.qrCodeURL) { image in
                        image.resizable().scaledToFit()
                    } placeholder: {
                        ProgressView("Loading QR code...")
                    }.frame(width: 250, height: 250)
                }
                
                // Delete button
                Button("Delete", systemImage: "xmark.circle", role: .destructive) {
                    showingDeleteConfirmation = true
                }.confirmationDialog(
                    "Are you sure you want to delete this short URL?",
                    isPresented: $showingDeleteConfirmation,
                    titleVisibility: .visible
                ) {
                    Button("Delete", role: .destructive) {
                        Task { await self.delete() }
                    }
                }
                
            }.buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
        }.contentMargins(.leading, 10, for: .scrollContent)
    }
    
    var body: some View {
        ScrollView {
            
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading) {
                    Section {
                        actions
                    } header: {
                        Text("Actions")
                            .font(.headline)
                            .padding(.horizontal)
                    }
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 10) {
                        if let url = item.shortURL?.absoluteString {
                            Label(url, systemImage: "link")
                                .accessibilityLabel("Short URL: \(url)")
                            
                            Divider()
                        }
                        
                        if let url = item.longURL?.absoluteString {
                            Label(url, systemImage: "arrow.right")
                                .accessibilityLabel("Long URL: \(url)")
                                .lineLimit(showingFullLongUrl ? nil : 1)
                                .onTapGesture {
                                    showingFullLongUrl.toggle()
                                }
                        }
                    }.padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(UIColor.secondarySystemGroupedBackground))
                        .clipShape(.rect(cornerRadius: 10))
                    
                    Section {
                        VisitsView(url: item, server: server)
                            .padding()
                    } header: {
                        Text("Statistics")
                            .font(.headline)
                    }
                }.padding(.horizontal)
            }
        }.navigationTitle("Short URL")
            .background(Color(UIColor.systemGroupedBackground))
    }
    
    private func delete() async {
        
    }
}

#Preview {
    let container = DataController.previewContainer
    
    return NavigationStack {
        ShortURLDetailView(item: .example)
            .environment(Server.previewServer())
    }.modelContainer(container)
}
