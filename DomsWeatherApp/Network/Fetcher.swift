//
//  Fetcher.swift
//  DomsWeatherApp
//
//  Created by Dominik Liehr on 28.05.24.
//

import Foundation

protocol WeatherFetching {
    func loadToday() async throws -> OneCallResponse
}

class Fetcher: WeatherFetching {
    func loadToday() async throws -> OneCallResponse {
        guard let url = URL(string:
                                "\(Constants.apiUrl)/onecall?lat=51.83&lon=8.14&units=metric&lang=de&appid=\(Constants.apiKey)")
        else { throw NetworkError.badRequestUrl }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200
        else { throw NetworkError.badResponse }

        return try JSONDecoder().decode(OneCallResponse.self, from: data)
    }
}

class MockFetcher: WeatherFetching {
    func loadToday() async throws -> OneCallResponse {
        guard let data = MockJsons.oneCallResult?.data(using: .utf8) else { throw NetworkError.noMockData }

        return try JSONDecoder().decode(OneCallResponse.self, from: data)
    }
}

enum NetworkError: Error {
    case badRequestUrl
    case badResponse
    case noMockData
}
