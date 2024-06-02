//
//  Constants.swift
//  DomsWeatherApp
//
//  Created by Dominik Liehr on 26.05.24.
//

import Foundation

class Constants {
    private init() {}

    static var apiKey: String { weatherApiKey }
    static let apiUrl = "https://api.openweathermap.org/data/3.0"

    class UserDefaultsKeys {
        private init() {}

        static let lastOneCallResponse = "lastOneCallResponse"
    }
}
