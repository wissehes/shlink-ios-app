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
    let decoder: JSONDecoder = .init()
    
    init(server: Server) {
        // Set server property
        self.server = server
        
        // Initialize client session object
        let configuration = URLSessionConfiguration.default
        configuration.headers.add(.accept("application/json"))
        configuration.headers.add(name: "X-Api-Key", value: server.apiKey)
        self.client =  Session(configuration: configuration)
        
        // Set the JSON date decoding strategy
        self.decoder.dateDecodingStrategy = .iso8601
    }
    
    // MARK: Short URLs
    
    /// Get all short URLs
    func getShortUrls() async throws -> [ShortURL] {
        let parameters: Parameters = [
            "itemsPerPage": 100
        ]
        
        let data = try await client.request(server.apiUrl + "/short-urls", parameters: parameters)
            .validate()
            .serializingDecodable(ShortUrlsResponse.self, decoder: self.decoder)
            .value
        
        return data.shortUrls.data
    }
    
    /// Create a short URL
    ///
    /// - Parameters:
    ///     - data: The payload to create a short URL.
    func createShortUrl(data: CreateShortURLPayload) async throws -> CreateShortURLResponse {
        let data = try await client.request(
            server.apiUrl + "/short-urls",
            method: .post,
            parameters: data,
            encoder: JSONParameterEncoder.default
        ).validate()
            .serializingDecodable(CreateShortURLResponse.self)
            .value
        
        return data
    }
    
    /// Delete a short URL
    func deleteShortUrl(item: ShortURL) async throws -> String {
        let response = try await client.request(
            server.apiUrl + "/short-urls/\(item.shortCode)",
            method: .delete
        ).validate()
            .serializingString()
            .value
        
        return response
    }
    
    // MARK: Server stats
    
    /// Get general visits stats not linked to one specific short URL.
    func getVisits() async throws -> GeneralVisits {
        let data = try await client.request(server.apiUrl + "/visits")
            .validate()
            .serializingDecodable(GetGeneralVisitsResponse.self)
            .value
        
        return data.visits
    }
}
