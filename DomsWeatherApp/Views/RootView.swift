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
    @State private var isLoading = false

    var body: some View {
        ZStack {
            if let weather = api.currentWeather,
               let firstWeather = weather.current.weather.first {
                ScrollView {
                    VStack {
                        HStack(alignment: .top, spacing: 0) {
                            VStack(alignment: .leading) {
                                Text(weather.current.timestamp.asDateString("HH:mm"))

                                Text(String(String(format: "%.0f°C", locale: .current, Float(weather.current.temp))))
                                    .font(.system(size: 32 + 32, weight: .bold))
                                    .padding([.top, .bottom], 4)

                                Text(firstWeather.main)
                                Text(firstWeather.description)
                            }

                            Spacer(minLength: 0)

                            ZStack {
                                Circle()
                                    .fill(.accentLight)
                                    .shadow(radius: 8)

                                if let url = URL(string: "https://openweathermap.org/img/wn/\(firstWeather.icon)@2x.png") {
                                    AsyncImage(url: url) { phase in
                                        if let image = phase.image {
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .shadow(radius: 8)

                                        } else if phase.error != nil {
                                            Image(systemName: "cloud.rainbow.half.fill")
                                                .symbolRenderingMode(.multicolor)
                                                .symbolEffect(.variableColor)
                                                .font(.system(size: 32))
                                        } else {
                                            ProgressView()
                                        }
                                    }
                                }
                            }
                            .frame(height: 100)
                        }

                        Divider()

                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(weather.hourlyToday(), id: \.timestamp) { hour in
                                    VStack {
                                        Text(hour.timestamp.asDateString("HH:mm"))

                                        if let firstWeather = hour.weather.first,
                                           let url = URL(string: "https://openweathermap.org/img/wn/\(firstWeather.icon)@2x.png") {
                                            AsyncImage(url: url) { phase in
                                                if let image = phase.image {
                                                    image
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(height: 48)

                                                } else if phase.error != nil {
                                                    Image(systemName: "cloud.rainbow.half.fill")
                                                        .symbolRenderingMode(.multicolor)
                                                        .symbolEffect(.variableColor)
                                                        .font(.system(size: 16))
                                                } else {
                                                    ProgressView()
                                                }
                                            }
                                        }

                                        Text(String(format: "%.0f°C", locale: .current, Float(hour.temp)))
                                    }
                                    .frame(width: 100)
                                }
                            }
                        }

                        Divider()
                    }
                    .padding()
                }
            }

            if isLoading {
                ProgressView()
            }
        }
        .task {
            isLoading = true

            do {
                try await api.loadToday()
            } catch {
                debugPrint(error)
            }

            isLoading = false
        }
    }
}

#Preview {
    WeatherApi.shared.fetching = MockFetcher()

    return RootView()
}
