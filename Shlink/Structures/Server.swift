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
    
    var apiUrl: String {
        return url + "/rest/v3"
    }
    
    var api: ShlinkAPI {
        ShlinkAPI(server: self)
    }
}

extension Server {
    static func previewServer() -> Server {
        guard let url = Bundle.main.object(forInfoDictionaryKey: "PREVIEW_SERVER_URL") as? String else {
            fatalError("No PREVIEW_SERVER_URL found in the bundle.")
        }
        guard let key = Bundle.main.object(forInfoDictionaryKey: "PREVIEW_SERVER_KEY") as? String else {
            fatalError("No PREVIEW_SERVER_KEY found in the bundle.")
        }
        
        return Server(name: "Preview Server", url: url, apiKey: key)
    }
}
