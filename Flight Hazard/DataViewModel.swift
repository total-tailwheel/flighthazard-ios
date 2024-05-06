// Flight Hazard/Flight Hazard/DataViewModel.swift

import SwiftUI

class DataViewModel: ObservableObject {
  @Published var airports: [Airport] = []
  @Published var flightPlans: [FlightPlan] = []

  init() {
    loadAirports()
    loadFlightPlans()
  }

  private func loadAirports() {
    FlightDataService.getAirports { (fetchedAirports, error) in
      DispatchQueue.main.async {
        if let airports = fetchedAirports {
          self.airports = airports
        } else if let error = error {
          print("Error fetching airports: \(error.localizedDescription)")
        }
      }
    }
  }

  private func loadFlightPlans() {
    FlightDataService.getFlightPlans { (fetchedPlans, error) in
      DispatchQueue.main.async {
        if let flightPlans = fetchedPlans {
          self.flightPlans = flightPlans
        } else if let error = error {
          print("Error fetching flight plans: \(error.localizedDescription)")
        }
      }
    }
  }
}
