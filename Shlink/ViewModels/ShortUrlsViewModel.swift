//
//  ShortUrlsViewModel.swift
//  Shlink
//
//  Created by Wisse Hes on 27/03/2024.
//

import Foundation
import SwiftUI

@Observable final class ShortUrlsViewModel {
    var server: Server
    
    init(server: Server) {
        self.server = server
    }
    
    var items: [ShlinkAPI.ShortURL]?
    
    var isLoading = true
    var error: Error?
    
    /// Get the short URLs from the server
    func fetch() async {
        do {
            let data = try await server.api.getShortUrls()
            self.items = data
        } catch {
            debugPrint(error)
            self.error = error
            self.items = nil
        }
        
        self.isLoading = false
    }
    
    func createShortUrl(data: CreateShortURLPayload) async throws {
        // Create the short url
        let data = try await server.api.createShortUrl(data: data)
        
        // Refresh the list of short urls
        await self.fetch()
    }
}
