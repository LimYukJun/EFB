//
//  SimBriefResponse.swift
//  EFB
//
//  Created by Yuk Jun Lim on 18/1/26.
//


import Foundation

struct SimBriefResponse: Decodable {
    let general: General
    let atc: ATC?
    let weights: Weights
    let fuel: Fuel
    let origin: Airport
    let destination: Airport
    let navlog: Navlog

    struct General: Decodable {
        let flight_number: String?
        let airline_icao: String?
        let airline_iata: String?
        let callsign: String?
    }
    
    struct ATC: Decodable {
        let callsign: String?
    }

    struct Weights: Decodable {
        let takeoff: String?
        let landing: String?
    }

    struct Fuel: Decodable {
        let plan_ramp: String?
    }

    struct Airport: Decodable {
        let icao_code: String?
        let plan_rwy: String?
        let time_out: String?
        let time_dep: String?
    }

    
    struct Navlog: Decodable {
        let fix: [Fix]

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            if let array = try? container.decode([Fix].self, forKey: .fix) {
                fix = array
            } else if let single = try? container.decode(Fix.self, forKey: .fix) {
                fix = [single]
            } else {
                fix = []
            }
        }

        enum CodingKeys: String, CodingKey {
            case fix
        }
    }


    struct Fix: Decodable {
        let ident: String
        let time_total: String?
        let fuel_plan_onboard: String?
    }


}

final class SimBriefService {
    func fetchOFP(pilotID: String) async throws -> SimBriefResponse {
        let urlString = "https://www.simbrief.com/api/xml.fetcher.php?userid=\(pilotID)&json=1"
        let url = URL(string: urlString)!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(SimBriefResponse.self, from: data)
    }
}
