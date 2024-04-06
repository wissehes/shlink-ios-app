//
//  AddServerView.swift
//  Shlink
//
//  Created by Wisse Hes on 06/04/2024.
//

import SwiftUI

struct AddServerView: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @Bindable var server = Server()
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $server.name)
                    TextField("Server URL", text: $server.url)
                        .keyboardType(.URL)
                        .textInputAutocapitalization(.never)
                    TextField("API Key", text: $server.apiKey)
                }
                
                Section {
                    Button("Test server") {
                        
                    }
                }
                
            }.navigationTitle("Add server")
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button("Save") {
                            self.save()
                        }
                    }
                    
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel", role: .cancel) {
                            dismiss()
                        }
                    }
                }
        }
    }
    
    func save() {
        modelContext.insert(server)
        dismiss()
    }
}

#Preview {
    let container = DataController.previewContainer
    
    return AddServerView()
        .modelContainer(container)
}
