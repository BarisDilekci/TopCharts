//
//  ListViewModel.swift
//  TopCharts
//
//  Created by Barış Dilekçi on 23.09.2024.
//

import Combine
import SwiftUI

@MainActor
class ListViewModel: ObservableObject {
    @Published var turkeyAlbums: [Album] = []
    @Published var globalAlbums: [Album] = []
    @Published var errorMessage: String?


    private let client: Client
    private let networkManager: NetworkManager

    init(client: Client = Client(), networkManager: NetworkManager = NetworkManager(baseUrl: "https://rss.applemarketingtools.com")) {
        self.client = client
        self.networkManager = networkManager
    }
    

    func fetchTurkeySong() async {
        guard let url = networkManager.buildURL(urlPath: .turkey) else { return  }
        var request = URLRequest(url: url)
        request.httpMethod = NetworkRequest.HTTPMethod.get.rawValue

        do {
            let albumResponse: AlbumResponse = try await client.fetch(type: AlbumResponse.self, with: request)
            turkeyAlbums = albumResponse.feed.results
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func fetchGlobalSong() async {
        guard let url = networkManager.buildURL(urlPath: .global) else { return  }
        var request = URLRequest(url: url)
        request.httpMethod = NetworkRequest.HTTPMethod.get.rawValue

        do {
            let albumResponse: AlbumResponse = try await client.fetch(type: AlbumResponse.self, with: request)
            globalAlbums = albumResponse.feed.results 
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    


}
