//
//  OneCallResponse.swift
//  DomsWeatherApp
//
//  Created by Dominik Liehr on 28.05.24.
//

import Foundation
import DevTools

typealias Millimeter = Float

struct OneCallResponse: Codable {
    var latitude: Float
    var longitude: Float
    var timeZone: String
    var timeZoneOffset: Int
    var current: Current
    var hourly: [Current]

    func hourlyToday() -> [Current] {
        let endOfNextDay = (Date().endOfDay?.adding(days: 1) ?? Date()).timeIntervalSince1970 + 1

        return hourly.filter { $0.timestamp <= Int64(endOfNextDay) }
    }

    enum CodingKeys: String, CodingKey {
        case current, hourly
        case latitude = "lat"
        case longitude = "lon"
        case timeZone = "timezone"
        case timeZoneOffset = "timezone_offset"
    }

    struct Current: Codable {
        var temp: Float
        var feelsLikeTemp: Float
        var pressure: Int
        var humidity: Int
        var windSpeed: Float
        var timestamp: Int
        var sunrise: Int?
        var sunset: Int?
        var weather: [Weather]
        var rain: Precipitation?
        var snow: Precipitation?

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

        struct Precipitation: Codable {
            var hour1: Millimeter?      // Precipitation, mm/h
            var hour3: Millimeter?      // Precipitation, mm/h

            enum CodingKeys: String, CodingKey {
                case hour1 = "1h"
                case hour3 = "3h"
            }
        }
    }
}
