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
    
}
