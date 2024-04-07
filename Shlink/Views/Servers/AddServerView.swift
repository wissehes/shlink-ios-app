//
//  AddServerView.swift
//  Shlink
//
//  Created by Wisse Hes on 06/04/2024.
//

import SwiftUI

/// View for adding a server to the saved server list
struct AddServerView: View {
    
    /// Enum for the server test result.
    /// Used for the result when testing the connection to a server
    enum TestResult {
        case none
        case testing
        case success
        case error
    }
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @Bindable var server = Server()
    
    @State private var testResult: TestResult = .none
    
    private func setTestResult(_ result: TestResult) {
        self.testResult = result
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $server.name)
                    TextField("Server URL", text: $server.url)
                        .keyboardType(.URL)
                        .textInputAutocapitalization(.never)
                        .textContentType(.URL)
                    TextField("API Key", text: $server.apiKey)
                        .keyboardType(.asciiCapable)
                        .textContentType(.password)
                }
                
                Section {
                    HStack {
                        Button("Test server") {
                            Task { await self.testServer() }
                        }
                        
                        Spacer()
                        
                        testResultView
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
    
    @ViewBuilder
    var testResultView: some View {
        switch testResult {
        case .none:
            EmptyView()
        case .testing:
            HStack(spacing: 10) {
                ProgressView()
                Text("Testing connection...")
            }
        case .success:
            Label("Connected successfully!", systemImage: "checkmark.circle")
                .foregroundStyle(.primary, .green)
        case .error:
            Label("Could not connect", systemImage: "exclamationmark.triangle.fill")
                .foregroundStyle(.primary, .yellow)
        }
    }
    
    func testServer() async {
        setTestResult(.testing)
        try? await Task.sleep(for: .seconds(2))
        
        do {
            let _ = try await server.api.getShortUrls()
            setTestResult(.success)
        } catch {
            setTestResult(.error)
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
