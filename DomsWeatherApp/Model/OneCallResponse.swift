//
//  OneCallResponse.swift
//  DomsWeatherApp
//
//  Created by Dominik Liehr on 28.05.24.
//

import Foundation

struct OneCallResponse: Codable {
    var latitude: Float16
    var longitude: Float16
    var timeZone: String
    var timeZoneOffset: Int16
    var current: Current

    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
        case timeZone = "timezone"
        case timeZoneOffset = "timezone_offset"
        case current
    }

    struct Current: Codable {
        var temp: Float16
        var feelsLikeTemp: Float16
        var pressure: Int16
        var humidity: Int8
        var windSpeed: Float16

        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLikeTemp = "feels_like"
            case pressure
            case humidity
            case windSpeed = "wind_speed"
        }
    }
}
