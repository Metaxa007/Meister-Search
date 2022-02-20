//
//  Endpoint.swift
//  Meister-Search
//
//  Created by Artsem Lemiasheuski on 16.02.22.
//

import Foundation

struct Endpoint {
    var path: String
    var queryItems: [URLQueryItem]

    private static let bearer = "2N6edq_uS3ACq89RhzN2yQtdT5aEhbKgaE5-P9BD3hc"
}

extension Endpoint {
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.meistertask.com"
        components.path = "/" + path
        components.queryItems = queryItems

        guard let url = components.url else {
            fatalError("Invalid URL")
        }

        return url
    }
}

extension Endpoint {
    static func filter(status: [Int], task: String) -> Self {
        Endpoint(path: "search", queryItems: [
            URLQueryItem(name: "filter", value: "{\"status\":\(status),\"text\":\"\(task)\"}"),
            URLQueryItem(name: "response_format", value: "object")
        ])
    }

    static func makeRequest(endpoint: URL) -> URLRequest {
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(bearer)", forHTTPHeaderField: "Authorization")

        return request
    }
}
