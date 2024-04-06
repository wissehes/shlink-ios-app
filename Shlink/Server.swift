//
//  Server.swift
//  Shlink
//
//  Created by Wisse Hes on 06/04/2024.
//

import Foundation
import SwiftData

/// Shlink server
@Model final class Server {
    /// Shlink server name or description
    var name: String
    
    /// Shlink server URL
    var url: String
    
    /// Shlink server API key
    var apiKey: String
    
    init(name: String = "", url: String = "", apiKey: String = "") {
        self.name = name
        self.url = url
        self.apiKey = apiKey
    }
}
