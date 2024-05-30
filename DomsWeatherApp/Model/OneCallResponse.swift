//
//  OneCallResponse.swift
//  DomsWeatherApp
//
//  Created by Dominik Liehr on 28.05.24.
//

import Foundation
import DevTools

struct OneCallResponse: Codable {
    var latitude: Float16
    var longitude: Float16
    var timeZone: String
    var timeZoneOffset: Int16
    var current: Current
    var hourly: [Current]

    func hourlyToday() -> [Current] {
        let endOfDay = (Date().endOfDay ?? Date()).timeIntervalSince1970 + 1

        return hourly.filter { $0.timestamp <= Int64(endOfDay) }
    }

    enum CodingKeys: String, CodingKey {
        case current, hourly
        case latitude = "lat"
        case longitude = "lon"
        case timeZone = "timezone"
        case timeZoneOffset = "timezone_offset"
    }

    struct Current: Codable {
        var temp: Float16
        var feelsLikeTemp: Float16
        var pressure: Int16
        var humidity: Int8
        var windSpeed: Float16
        var timestamp: Int32
        var sunrise: Int32?
        var sunset: Int32?
        var weather: [Weather]
        var rain: Rain?

        enum CodingKeys: String, CodingKey {
            case temp, pressure, humidity, sunrise, sunset, weather, rain
            case feelsLikeTemp = "feels_like"
            case windSpeed = "wind_speed"
            case timestamp = "dt"
        }

        struct Weather: Codable {
            var id: Int
            var main: String
            var description: String
            var icon: String
            var iconURL: URL? { URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png") }
        }

        struct Rain: Codable {
            var hour1: Float

            enum CodingKeys: String, CodingKey {
                case hour1 = "1h"
            }
        }
    }
}
