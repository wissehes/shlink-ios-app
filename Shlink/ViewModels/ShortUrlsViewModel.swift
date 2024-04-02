//
//  ShortUrlsViewModel.swift
//  Shlink
//
//  Created by Wisse Hes on 27/03/2024.
//

import Foundation
import SwiftUI

@Observable final class ShortUrlsViewModel {
    var items: [Shlink.ShortURL]?
    
    var isLoading = true
    var error: Error?
    
    /// Get the short URLs from the server
    func fetch() async {
        do {
            let data = try await Shlink.shared.getShortUrls()
            self.items = data
        } catch {
            debugPrint(error)
            self.error = error
            self.items = nil
        }
        
        self.isLoading = false
    }
}
