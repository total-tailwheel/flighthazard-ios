// File path: Flight Hazard/Flight Hazard/FlightDataService.swift

import Foundation

struct Airport: Decodable, Hashable, Identifiable {
  var id: String { icao_code }
  var icao_code: String
}

struct FlightPlan: Decodable, Hashable, Identifiable {
  var id = UUID()
  var departure_airport: Airport
  var destination_airport: Airport
  var departure_time: Date

  enum CodingKeys: String, CodingKey {
    case departure_airport, destination_airport, departure_time
  }

  init(departure_airport: Airport, destination_airport: Airport, departure_time: Date) {
    self.departure_airport = departure_airport
    self.destination_airport = destination_airport
    self.departure_time = departure_time
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    departure_airport = try container.decode(Airport.self, forKey: .departure_airport)
    destination_airport = try container.decode(Airport.self, forKey: .destination_airport)

    let dateFormatter = ISO8601DateFormatter()
    dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

    let dateStr = try container.decode(String.self, forKey: .departure_time)
    guard let date = dateFormatter.date(from: dateStr) else {
      throw DecodingError.dataCorruptedError(
        forKey: .departure_time,
        in: container,
        debugDescription: "Date string does not match format expected by formatter.")
    }
    departure_time = date
  }
}

// Data service for fetching airports and flight plans.
struct FlightDataService {
  // Generic data fetching function
  private static func fetchData<T: Decodable>(
    from url: URL, completion: @escaping (T?, Error?) -> Void
  ) {
    var request = URLRequest(url: url)
    request.setValue("no-cache, no-store, must-revalidate", forHTTPHeaderField: "Cache-Control")
    request.setValue("no-cache", forHTTPHeaderField: "Pragma")
    request.setValue("0", forHTTPHeaderField: "Expires")

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      if let error = error {
        completion(nil, error)
        return
      }
      guard let data = data, let decoded = try? JSONDecoder().decode(T.self, from: data) else {
        completion(nil, NSError(domain: "", code: -1, userInfo: nil))
        return
      }
      completion(decoded, nil)
    }
    task.resume()
  }

  static func getAirports(completion: @escaping ([Airport]?, Error?) -> Void) {
    let url = URL(string: "http://localhost:4000/api/airports")!
    fetchData(from: url, completion: completion)
  }

  static func getFlightPlans(completion: @escaping ([FlightPlan]?, Error?) -> Void) {
    let url = URL(string: "http://localhost:4000/api/flight-plans")!
    fetchData(from: url, completion: completion)
  }
}
