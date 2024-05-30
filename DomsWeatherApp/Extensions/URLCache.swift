//
//  URLCache.swift
//  DomsWeatherApp
//
//  Created by Dominik Liehr on 30.05.24.
//

import Foundation

extension URLCache {
    static let imageCache = URLCache(memoryCapacity: 10_000_000, diskCapacity: 100_000_000) // sizes in bytes
}
