//
//  ShlinkAPI.swift
//  Shlink
//
//  Created by Wisse Hes on 06/04/2024.
//

import Foundation
import Alamofire

final class ShlinkAPI {
    
    let server: Server
    let client: Session
    
    init(server: Server) {
        // Set server property
        self.server = server
        
        // Initialize client session object
        let configuration = URLSessionConfiguration.default
        configuration.headers.add(.accept("application/json"))
        configuration.headers.add(name: "X-Api-Key", value: server.apiKey)
        self.client =  Session(configuration: configuration)
    }
    
    /// Get all short URLs
    func getShortUrls() async throws -> [ShortURL] {
        let data = try await client.request(server.url + "/short-urls")
            .validate()
            .serializingDecodable(ShortUrlsResponse.self)
            .value
        
        return data.shortUrls.data
    }
    
    /// Create a short URL
    ///
    /// - Parameters:
    ///     - data: The payload to create a short URL.
    func createShortUrl(data: CreateShortURLPayload) async throws -> CreateShortURLResponse {
        let data = try await client.request(
            server.url + "/short-urls",
            method: .post,
            parameters: data,
            encoder: JSONParameterEncoder.default
        ).validate()
            .serializingDecodable(CreateShortURLResponse.self)
            .value
        
        return data
    }
}