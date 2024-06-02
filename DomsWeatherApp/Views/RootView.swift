//
//  ContentView.swift
//  DomsWeatherApp
//
//  Created by Dominik Liehr on 26.05.24.
//

import SwiftUI
import DevTools
import CachedAsyncImage

struct RootView: View {
    @Environment(\.scenePhase) private var scenePhase

    @State private var monitor = NetworkMonitor.shared
    @State private var api = WeatherApi.shared

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

                                CachedAsyncImage(url: firstWeather.iconURL) { phase in
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
                            .frame(height: 100)
                        }

                        Divider()

                        ScrollView(.horizontal) {
                            HStack(alignment: .top) {
                                Divider()

                                ForEach(weather.hourlyToday(), id: \.timestamp) { hour in
                                    VStack {
                                        HStack(alignment: .top, spacing: 0) {
                                            Text(hour.timestamp.asDateString("HH:mm"))
                                                .font(.system(size: 14))

                                            Spacer(minLength: 0)

                                            Text(String(format: "%.0f°C", locale: .current, Float(hour.temp)))
                                                .font(.system(size: 22))
                                                .padding(.top, -2)
                                        }


                                        if let firstWeather = hour.weather.first {
                                            CachedAsyncImage(url: firstWeather.iconURL) { phase in
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

                                        if let rain = hour.rain {
                                            getPrecipitationView(rain, forRain: true)
                                        }

                                        if let snow = hour.snow {
                                            getPrecipitationView(snow, forRain: false)
                                        }
                                    }
                                    .frame(width: 100)

                                    Divider()
                                }
                            }
                        }

                        Divider()
                    }
                    .padding()
                }
                .refreshable {
                    loadToday()
                }
            }

            if api.isLoading {
                ProgressView()
                    .padding()
                    .background(Color.red)
                    .clipShape(Circle())
            }
        }
        .task {
            await loadToday()
        }
        .onChange(of: monitor.isConnected) { connectedBefore, connectedNow in
            guard !connectedBefore, connectedNow else { return }

            loadToday()
        }
        .onChange(of: scenePhase) { oldValue, newValue in
            guard oldValue == .background, newValue == .active else { return }

            loadToday()
        }
    }

    private func loadToday() {
        Task {
            await loadToday()
        }
    }

    private func loadToday() async {
        do {
            try await api.tryLoadToday()
        } catch {
            debugPrint(error)
        }
    }

    private func getPrecipitationView(_ precipitation: OneCallResponse.Current.Precipitation,
                                      forRain: Bool) -> some View {

        HStack {
            Image(systemName: forRain ? "cloud.rain.fill" : "")
                .foregroundStyle(Color.accentColor)

            if let hour1 = precipitation.hour1 {
                Text(String(format: "%.1fmm / 1h", locale: .current, hour1))
            } else if let hour3 = precipitation.hour3 {
                Text(String(format: "%.1fmm / 3h", locale: .current, hour3))
            }

            Spacer()
        }
        .font(.system(size: 12))
    }
}

#Preview {
    WeatherApi.shared.fetching = MockFetcher()

    return RootView()
}
