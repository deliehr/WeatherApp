//
//  Fetcher.swift
//  DomsWeatherApp
//
//  Created by Dominik Liehr on 28.05.24.
//

import Foundation

enum NetworkError: Error {
    case badRequestUrl
    case badResponse
    case noMockData
    case lastResponseNotExisting
}

protocol WeatherFetching {
    func loadToday() async throws -> OneCallResponse
    func loadLastToday() async throws -> OneCallResponse
}

// MARK: - default api data

class Fetcher: WeatherFetching {
    func loadToday() async throws -> OneCallResponse {
        guard let url = createUrl(latitude: 51.83, longitude: 8.14) else { throw NetworkError.badRequestUrl }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200
        else { throw NetworkError.badResponse }

        return try JSONDecoder().decode(OneCallResponse.self, from: data)
    }

    func loadLastToday() async throws -> OneCallResponse {
        guard let json = UserDefaults.standard.string(forKey: Constants.UserDefaultsKeys.lastOneCallResponse),
              let data = json.data(using: .utf8)
        else { throw NetworkError.lastResponseNotExisting }

        return try JSONDecoder().decode(OneCallResponse.self, from: data)
    }

    private func createUrl(latitude: Float, longitude: Float) -> URL? {
        URL(string: "\(Constants.apiUrl)/onecall" +
            "?lat=\(latitude)" +
            "&lon=\(longitude)" +
            "&units=metric" +
            "&lang=de" +
            "&appid=\(Constants.apiKey)")
    }
}

// MARK: - mock data

class MockFetcher: WeatherFetching {
    func loadToday() async throws -> OneCallResponse {
        guard let data = MockJsons.oneCallResult?.data(using: .utf8) else { throw NetworkError.noMockData }

        return try JSONDecoder().decode(OneCallResponse.self, from: data)
    }

    func loadLastToday() async throws -> OneCallResponse {
        try await loadToday()
    }
}
