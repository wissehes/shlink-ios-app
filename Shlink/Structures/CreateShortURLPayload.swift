//
//  CreateShortURLPayload.swift
//  Shlink
//
//  Created by Wisse Hes on 06/04/2024.
//

import Foundation

/// Payload for creating a short URL
struct CreateShortURLPayload: Codable {
    var longUrl: String
    var customSlug: String? = nil
    
    /// Forward query params on redirect
    var forwardQuery: Bool = true
    /// Whether the short URL is crawlable by search engines
    var crawlable: Bool = false
    
    var tags: [String] = []
}

struct CreateShortURLResponse: Codable {
    let shortCode: String
    let shortUrl: String
    let longUrl: String
    let tags: [String]
    
    let title: String?
}
