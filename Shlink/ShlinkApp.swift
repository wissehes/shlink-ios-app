//
//  ShlinkApp.swift
//  Shlink
//
//  Created by Wisse Hes on 24/03/2024.
//

import SwiftUI

@main
struct ShlinkApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Server.self)
        }
    }
}
