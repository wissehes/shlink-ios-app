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
        defer {
            withAnimation { self.isLoading = false }
        }
        
        do {
            let data = try await server.api.getShortUrls()
            self.items = data
            self.error = nil
        } catch {
            debugPrint(error)
            self.error = error
            self.items = nil
        }
    }
    
    func createShortUrl(data: CreateShortURLPayload) async throws {
        // Create the short url
        let _ = try await server.api.createShortUrl(data: data)
        
        // Refresh the list of short urls
        await self.fetch()
    }
}
