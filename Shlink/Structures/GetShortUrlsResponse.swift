//
//  GetShortUrlsResponse.swift
//  Shlink
//
//  Created by Wisse Hes on 06/04/2024.
//

import Foundation

extension ShlinkAPI {
    
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
        let dateCreated: Date
        let visitsCount: Int
        let tags: [String]
//        let meta: Meta
//        let domain: JSONNull?
        let title: String?
        let crawlable, forwardQuery: Bool
        
        var qrCodeURL: URL? {
            URL(string: shortURL + "/qr-code")
        }

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

extension ShlinkAPI.ShortURL {
    static let example = ShlinkAPI.ShortURL(
        shortCode: "QRMqJ",
        shortURL: "https://test.com/QRMqJ",
        longURL: "https://google.com",
        dateCreated: .now,
        visitsCount: 5,
        tags: [],
        title: nil,
        crawlable: false,
        forwardQuery: true
    )
}
