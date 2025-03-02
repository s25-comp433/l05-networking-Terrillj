//
//  ContentView.swift
//  BasketballGames
//
//  Created by Samuel Shi on 2/27/25.
//

import SwiftUI

struct Score: Codable {
    var unc: Int
    var opponent: Int
}

struct Game: Codable {
    var id: Int
    var team: String
    var score: Score
    var date: String
    var opponent: String
    var isHomeGame: Bool
}

struct ContentView: View {
    @State private var results = [Game]()
    var body: some View {
        List(results, id: \.id) { item in
            HStack {
                VStack(alignment: .leading) {
                    Text("\(item.team) vs. \(item.opponent)")
                        .font(.headline)
                    Text(item.date)
                        .foregroundStyle(.secondary)
                        .font(.caption)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("\(item.score.unc) - \(item.score.opponent)")
                    Text(item.isHomeGame ? "Home" : "Away")
                        .foregroundStyle(.secondary)
                        .font(.caption)
                }
            }
            
        }.task {
            await loadData()
        }
    }
    
    func loadData() async {
        guard let url = URL(string: "https://api.samuelshi.com/uncbasketball") else {
            print("invalid url")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode([Game].self, from: data) {
                results = decodedResponse
            }
        } catch {
            print("Invalid data")
        }
    }
}

#Preview {
    ContentView()
}
