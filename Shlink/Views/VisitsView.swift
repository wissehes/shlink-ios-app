//
//  VisitsView.swift
//  Shlink
//
//  Created by Wisse Hes on 08/04/2024.
//

import SwiftUI
import Charts

struct VisitsView: View {
    
    class VisitDay: Identifiable {
        var id: String { date.ISO8601Format() }
        var date: Date
        var visits: Int

        init(date: Date, visits: Int) {
            self.date = date
            self.visits = visits
        }
    }
    
    var url: ShlinkAPI.ShortURL
    var server: Server
    
    @State private var visits: [ShlinkAPI.Visit]?
    
    var visitsPerDay: [VisitDay] {
        guard
            let visits = visits?.sorted(by: { $0.date.compare($1.date) == .orderedAscending })
        else { return [] }
        
        guard
            let earliestDate = visits.first?.date,
            let latestDate = visits.last?.date
        else { return [] }
        
        guard let daysBetween = Calendar.current.dateComponents([.day], from: earliestDate, to: latestDate).day else { return [] }

        var days: [VisitDay] = []
        
        for i in 0...daysBetween {
            guard let newDate = Calendar.current.date(byAdding: .day, value: i, to: earliestDate) else { continue }
            
            days.append(.init(date: newDate, visits: 0))
        }
        
        for visit in visits {
            if let foundDay = days.first(where: { day in
                Calendar.current.isDate(day.date, inSameDayAs: visit.date)
            }) {
                foundDay.visits += 1
            } else {
                days.append(.init(date: visit.date, visits: 1))
            }
        }
        
        return days
    }
    
    func loadData() async {
        do {
            let data = try await server.api.getVisits(for: url)
            self.visits = data
        } catch {
            debugPrint(error)
        }
    }
    
    var body: some View {
        Group {
            if visits != nil {
                Chart(visitsPerDay) {
                    LineMark(
                        x: .value("Date", $0.date, unit: .day),
                        y: .value("Visits", $0.visits)
                    ).interpolationMethod(.cardinal)
                        .chartXSc
                }
            } else {
                ProgressView("Loading...")            }
        }
            .task(id: url.shortCode) { await self.loadData() }
    }
}

#Preview {
    let container = DataController.previewContainer
    let server = Server.previewServer()
    
    return VisitsView(url: .example, server: server)
        .modelContainer(container)
}

#Preview {
    let container = DataController.previewContainer
    
    return ContentView()
        .modelContainer(container)
}
