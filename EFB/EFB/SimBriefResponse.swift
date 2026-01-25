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
    let alternate: Airport
    let navlog: Navlog
    let files: SimBriefFiles?

    struct General: Decodable {
        let flight_number: String?
        let icao_airline: String?
        let airline_iata: String?
        let callsign: String?
        let stepclimb_string: String?
        let route: String?
    }
    
    struct ATC: Decodable {
        let callsign: String?
    }

    struct Weights: Decodable {
        let takeoff: String?
        let landing: String?
    }

    struct Fuel: Decodable {
        let taxi: String?
        let enroute_burn: String?
        let contingency: String?
        let alternate_burn: String?
        let reserve: String?
        let etops: String?
        let extra: String?
        let min_takeoff: String?
        let plan_takeoff: String?
        let plan_ramp: String?
        let plan_landing: String?
    }


    struct Airport: Decodable {
        let icao_code: String?
        let plan_rwy: String?
        let time_out: String?
        let time_dep: String?
        let notam: OneOrMany<SimBriefNotam>?

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
    struct SimBriefFiles: Decodable {
        let directory: String
        let pdf: SimBriefPDF?
    }

    struct SimBriefPDF: Decodable {
        let name: String
        let link: String
    }

    struct SimBriefNotam: Decodable {
        let notam_raw: String?
    }



}

final class SimBriefService {

    struct OFPResult {
        let response: SimBriefResponse
        let pdfLink: String?
    }

    func fetchOFP(pilotID: String) async throws -> OFPResult {
        let urlString = "https://www.simbrief.com/api/xml.fetcher.php?userid=\(pilotID)&json=1"
        let url = URL(string: urlString)!
        let (data, _) = try await URLSession.shared.data(from: url)

        let response = try JSONDecoder().decode(SimBriefResponse.self, from: data)

        let pdfLink: String? = {
            guard
                let directory = response.files?.directory,
                let file = response.files?.pdf?.link
            else {
                return nil
            }
            return directory + file
        }()

        return OFPResult(response: response, pdfLink: pdfLink)
    }


}
struct OneOrMany<T: Decodable>: Decodable {
    let values: [T]

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let array = try? container.decode([T].self) {
            values = array
        } else if let single = try? container.decode(T.self) {
            values = [single]
        } else {
            values = []
        }
    }
}
