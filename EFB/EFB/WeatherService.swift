//
//  WeatherService.swift
//  EFB
//
//  Created by Yuk Jun Lim on 18/1/26.
//


import Foundation

struct METAR: Decodable {
    let rawOb: String
}

final class WeatherService {
    func fetchMETAR(icao: String) async throws -> String {
        let urlString = "https://aviationweather.gov/api/data/metar?ids=\(icao)&format=json"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let metars = try JSONDecoder().decode([METAR].self, from: data)

        return metars.first?.rawOb ?? "No METAR available"
    }
}
