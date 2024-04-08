//
//  GetVisitsResponse.swift
//  Shlink
//
//  Created by Wisse Hes on 07/04/2024.
//

import Foundation

extension ShlinkAPI {
 
    struct GetGeneralVisitsResponse: Codable {
        let visits: GeneralVisits
    }
    
    struct GeneralVisits: Codable {
        let orphanVisitsCount: Int
        let visitsCount: Int
    }
    
    struct GetVisitsResponse: Codable {
        let visits: GetVisitsResponseData
    }
    
    struct GetVisitsResponseData: Codable {
        let data: [Visit]
//        let pagination: ..
    }
    
    struct Visit: Codable {
        let referer: String?
        let date: Date
        let userAgent: String
        let visitLocation: Location?
        let potentialBot: Bool
        
        struct Location: Codable {
            let cityName, countryCode, countryName: String
            let latitude, longitude: Double
            let regionName, timezone: String
        }
    }
}
