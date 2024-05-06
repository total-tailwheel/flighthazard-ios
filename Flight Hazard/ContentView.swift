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
  @EnvironmentObject var dataViewModel: DataViewModel  // Access ViewModel

  var body: some View {
    ScrollView {
      VStack {
        Text("Airports")
          .font(.headline)
          .padding()

        List(dataViewModel.airports, id: \.icao_code) { airport in
          AirportView(airport: airport)
        }
        .frame(height: 200)

        Text("Flight Plans")
          .font(.headline)
          .padding()

        List(dataViewModel.flightPlans, id: \.departure_airport) { flightPlan in
          FlightPlanView(flightPlan: flightPlan)
        }
        .frame(height: 200)
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
