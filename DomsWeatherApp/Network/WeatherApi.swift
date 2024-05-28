//
//  WeatherApi.swift
//  DomsWeatherApp
//
//  Created by Dominik Liehr on 28.05.24.
//

import Foundation

@Observable
class WeatherApi {
    var currentWeather: OneCallResponse?

    @ObservationIgnored
    var fetching: WeatherFetching = Fetcher()

    static let shared = WeatherApi()

    private init() {}

    func loadToday() async throws {
        currentWeather = try await fetching.loadToday()
    }
}
