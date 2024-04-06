//
//  DataController.swift
//  Shlink
//
//  Created by Wisse Hes on 06/04/2024.
//

import Foundation
import SwiftData

/// Data controller for previews
@MainActor
class DataController {
    
    /// SwiftData container for using with previews
    ///
    /// Example:
    /// ```swift
    /// ExampleView()
    ///     .modelContainer(DataController.previewContainer)
    /// ```
    ///
    static let previewContainer: ModelContainer = {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: Server.self, configurations: config)
            
            let server = Server.previewServer()
            container.mainContext.insert(server)
            
            return container
            
        } catch {
            fatalError("Failed to create a model container for previewing. \(error.localizedDescription)")
        }
    }()
}
