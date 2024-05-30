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
        let mockFile = (0...5).map({ "mock\($0)" }).randomElement() ?? "mock0"

        guard let path = Bundle.main.path(forResource: mockFile, ofType: "json"),
                let content = try? String(contentsOfFile: path, encoding: .utf8)
        else { return nil }

        return content
    }()
}
