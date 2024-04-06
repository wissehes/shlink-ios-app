//
//  ShortUrlsOverview.swift
//  Shlink
//
//  Created by Wisse Hes on 26/03/2024.
//

import SwiftUI

struct ShortUrlsOverview: View {

    var vm: ShortUrlsViewModel

    var body: some View {
        Group {
            if vm.isLoading {
                ProgressView("Loading...")
            } else if let items = vm.items {
                List(items, id: \.shortCode) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.title ?? item.shortCode)
                                .lineLimit(1)
                                .bold()
                            Text(item.longURL)
                                .lineLimit(1)
                        }
                        
                        Spacer()
                        
                        Text("**\(item.visitsCount, format: .number)**\n visits")
                            .multilineTextAlignment(.center)
                    }
                }
            } else {
                ContentUnavailableView(
                    "No short URLs",
                    systemImage: "link",
                    description: Text(vm.error?.localizedDescription ?? "Somewthing went wrong.")
                )
            }
        }.task { await vm.fetch() }
            .refreshable { await vm.fetch() }
    }
}

#Preview {
    ShortUrlsOverview(vm: .init(server: .previewServer()))
}
