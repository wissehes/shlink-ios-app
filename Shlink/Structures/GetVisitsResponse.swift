//
//  GetVisitsResponse.swift
//  Shlink
//
//  Created by Wisse Hes on 07/04/2024.
//

import Foundation

extension ShlinkAPI {
 
    struct GetVisitsResponse: Codable {
        let visits: Visits
    }
    
    struct Visits: Codable {
        let orphanVisitsCount: Int
        let visitsCount: Int
    }
    
}
