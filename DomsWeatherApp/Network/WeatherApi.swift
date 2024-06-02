//
//  WeatherApi.swift
//  DomsWeatherApp
//
//  Created by Dominik Liehr on 28.05.24.
//

import DevTools
import SwiftUI

@Observable
class WeatherApi {
    var currentWeather: OneCallResponse?
    var isLoading = false

    @ObservationIgnored
    var fetching: WeatherFetching = Fetcher()

    static let shared = WeatherApi()

    func tryLoadToday() async throws {
        guard !isLoading else { return }

        defer { isLoading = false }

        isLoading = true

        currentWeather = NetworkMonitor.shared.isConnected
            ? try await fetching.loadToday()
            : try await fetching.loadLastToday()

        guard let currentWeather else { return }

        Task(priority: .low) { [currentWeather] in
            guard let json = try? JSONEncoder().encode(currentWeather) else { return }

            UserDefaults.standard.setValue(json, forKey: Constants.UserDefaultsKeys.lastOneCallResponse)
        }
    }
}
