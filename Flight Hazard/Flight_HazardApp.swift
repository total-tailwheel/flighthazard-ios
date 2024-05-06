//
//  Flight_HazardApp.swift
//  Flight Hazard
//
//  Created by Kevin Gilpin on 5/2/24.
//

import SwiftUI

@main
struct Flight_HazardApp: App {
  @StateObject private var dataViewModel = DataViewModel()

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(dataViewModel)
    }
  }
}
