//
//  Flight_HazardApp.swift
//  Flight Hazard
//
//  Created by Kevin Gilpin on 5/2/24.
//

import SwiftUI

@main
struct Flight_HazardApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView(airports: .constant([]), flightPlans: .constant([]))
    }
  }
}
    