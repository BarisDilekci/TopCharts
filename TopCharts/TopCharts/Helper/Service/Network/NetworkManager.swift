//
//  NetworkManager.swift
//  TopCharts
//
//  Created by Barış Dilekçi on 24.09.2024.
//

import Foundation


enum URLPath: String {
    case turkey = "/api/v2/tr/music/most-played/25/songs.json"
    case global = "/api/v2/us/music/most-played/25/songs.json"
}

struct NetworkRequest {
    let method: HTTPMethod
    let url: URL
}

class NetworkManager {
    private let baseUrl: URL?
    
    init(baseUrl: String) {
        self.baseUrl = URL(string: baseUrl)
        
        guard self.baseUrl != nil else {
            fatalError("Geçersiz base URL: \(baseUrl)")
        }
    }
    
    func buildURL(urlPath: URLPath) -> URL? {
        guard let baseUrl = baseUrl else {
            return nil 
        }
        return baseUrl.appendingPathComponent(urlPath.rawValue)
    }
}

extension NetworkRequest {
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
}
