// File path: Flight Hazard/Flight Hazard/ContentView.swift

//
//  ContentView.swift
//  Flight Hazard
//
//  Created by Kevin Gilpin on 5/2/24.
//  Modified by Navie on 5/3/24 to include airport and flight plan lists.
//

import SwiftUI

struct ContentView: View {
  @Binding var airports: [Airport]
  @Binding var flightPlans: [FlightPlan]

  var body: some View {
    ScrollView {
      VStack {
        Text("Airports")
          .font(.headline)
          .padding()

        List(airports, id: \.icao_code) { airport in
          AirportView(airport: airport)
        }
        .frame(height: 200)
        .onAppear {
          FlightDataService.getAirports { (fetchedAirports, error) in
            if let airports = fetchedAirports {
              self.airports = airports
            } else if let error = error {
              print("Error fetching airports: \(error.localizedDescription)")
            }
          }
        }

        Text("Flight Plans")
          .font(.headline)
          .padding()

        List(flightPlans, id: \.departure_airport) { flightPlan in
          FlightPlanView(flightPlan: flightPlan)
        }
        .frame(height: 200)
        .onAppear {
          FlightDataService.getFlightPlans { (fetchedPlans, error) in
            if let flightPlans = fetchedPlans {
              self.flightPlans = flightPlans
            } else if let error = error {
              print("Error fetching flight plans: \(error.localizedDescription)")
            }
          }
        }
      }
    }
  }
}

struct AirportView: View {
  var airport: Airport

  var body: some View {
    Text(airport.icao_code)
  }
}

struct FlightPlanView: View {
  var flightPlan: FlightPlan

  var body: some View {
    VStack(alignment: .leading) {
      Text(
        "From: \(flightPlan.departure_airport.icao_code) To: \(flightPlan.destination_airport.icao_code)"
      )
      .font(.subheadline)
      Text("Date: \(flightPlan.departure_time, style: .date)")
        .font(.caption)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    // Mock data for preview purposes
    let mockAirports = [Airport(icao_code: "XYZ"), Airport(icao_code: "ABC")]
    let mockFlightPlans = [
      FlightPlan(
        departure_airport: mockAirports[0], destination_airport: mockAirports[1],
        departure_time: Date()
      )
    ]

    // Creating bindings from state
    let airportsBinding = Binding.constant(mockAirports)
    let flightPlansBinding = Binding.constant(mockFlightPlans)

    // Or: .constant([Airport(icao_code: "SampleICAO")])
    // Or: .constant([FlightPlan(departure_airport: Airport(icao_code: "SampleICAO"), destination_airport: Airport(icao_code: "SampleICAO"), departure_time: Date())])
    ContentView(airports: airportsBinding, flightPlans: flightPlansBinding)
  }
}
