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
        List {
            ForEach(vm.items ?? [], id: \.shortCode) { item in
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.title)
                            .bold()
                        Text(item.shortURL)
                    }
                    
                    Spacer()
                    
                    Text("**\(item.visitsCount, format: .number)**\n visits")
                        .multilineTextAlignment(.center)
                }
            }
        }.task { await vm.fetch() }
            .refreshable { await vm.fetch() }
    }
}

#Preview {
    ShortUrlsOverview(vm: .init())
}
