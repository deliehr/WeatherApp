//
//  ContentView.swift
//  DomsWeatherApp
//
//  Created by Dominik Liehr on 26.05.24.
//

import SwiftUI
import DevTools

struct RootView: View {
    @State private var api = WeatherApi.shared

    var body: some View {
        VStack {
            if let weather = api.currentWeather {
                Text(weather.timeZone)
                Text(String(weather.current.temp))
                Text(weather.current.datetime.asDateString("E, d MMM yyyy HH:mm"))
            }
        }
        .task {
            try? await api.loadToday()
        }
    }
}

#Preview {
    WeatherApi.shared.fetching = MockFetcher()

    return RootView()
}
