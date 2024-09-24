//
//  GenericAPI.swift
//  TopCharts
//
//  Created by Barış Dilekçi on 24.09.2024.
//

import Foundation

protocol GenericAPI {
    var session: URLSessionProtocol { get }
    func fetch<T: Codable>(type: T.Type, with request: URLRequest) async throws -> T
}

extension GenericAPI {
    func fetch<T: Codable>(type: T.Type, with request: URLRequest) async throws -> T {
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.requestFailed(description: "Invalid Response")
        }
        guard httpResponse.statusCode == 200 else {
            throw APIError.responseUnsuccessful(description: "Status code: \(httpResponse.statusCode)")
        }
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(type, from: data)
        } catch {
            print(error)
            throw APIError.jsonConversionFailure(description: error.localizedDescription)
        }
    }
}
