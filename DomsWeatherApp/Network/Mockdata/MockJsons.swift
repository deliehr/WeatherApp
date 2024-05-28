//
//  MockJsons.swift
//  DomsWeatherApp
//
//  Created by Dominik Liehr on 28.05.24.
//

import Foundation

class MockJsons {
    private init() {}

    static let oneCallResult: String? = {
        let mock = ["mock0", "mock1"].randomElement() ?? "mock0"

        guard let path = Bundle.main.path(forResource: mock, ofType: "json"),
                let content = try? String(contentsOfFile: path, encoding: .utf8)
        else { return nil }

        return content
    }()
}
