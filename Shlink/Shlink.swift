//
//  Shlink.swift
//  Shlink
//
//  Created by Wisse Hes on 24/03/2024.
//

import Foundation
import Alamofire

final class Shlink {
    
    static let apiKey = ""
    static let baseUrl = ""
    
    static let shared = Shlink()
    
    let client: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.headers.add(.accept("application/json"))
        configuration.headers.add(name: "X-Api-Key", value: Shlink.apiKey)
        return Session(configuration: configuration)
    }()
    
    func getShortUrls() async throws -> [ShortURL] {
        let data = try await client.request(Self.baseUrl + "/short-urls")
            .validate()
            .serializingDecodable(ShortUrlsResponse.self)
            .value
        
        return data.shortUrls.data
    }
    
    func createShortUrl(data: CreateShortURLPayload) async throws -> CreateShortURLResponse {
        let data = try await client.request(
            Self.baseUrl + "/short-urls",
            method: .post,
            parameters: data,
            encoder: JSONParameterEncoder.default
        ).validate()
            .serializingDecodable(CreateShortURLResponse.self)
            .value
        
        return data
    }
    
}


extension Shlink {
    
    struct ShortUrlsResponse: Codable {
        let shortUrls: ShortUrls
    }
    
    struct ShortUrls: Codable {
        let data: [ShortURL]
        let pagination: Pagination
    }
    
    // MARK: - ShortURL
    struct ShortURL: Codable {
        let shortCode: String
        let shortURL: String
        let longURL: String
        let dateCreated: String
        let visitsCount: Int
        let tags: [String]
//        let meta: Meta
//        let domain: JSONNull?
        let title: String?
        let crawlable, forwardQuery: Bool

        enum CodingKeys: String, CodingKey {
            case shortCode
            case shortURL = "shortUrl"
            case longURL = "longUrl"
            case dateCreated, visitsCount, tags, title, crawlable, forwardQuery
        }
    }
    
    // MARK: - Pagination
    struct Pagination: Codable {
        let currentPage, pagesCount, itemsPerPage, itemsInCurrentPage: Int
        let totalItems: Int
    }
}
