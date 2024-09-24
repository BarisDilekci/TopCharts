//
//  Song.swift
//  TopCharts
//
//  Created by Barış Dilekçi on 23.09.2024.
//

import Foundation

struct AlbumResponse: Codable {
    let feed: AlbumFeed
}

struct AlbumFeed: Codable {
    let results: [Album]
}

struct Album: Codable, Identifiable {
    let artistName: String
    let name: String
    let id: String
    let releaseDate: String
    let url: String
    let artworkUrl100: String
    let genres: [Genre]
    
    enum CodingKeys: String, CodingKey {
        case artistName
        case name
        case id
        case releaseDate
        case url
        case artworkUrl100
        case genres
    }
}

struct Genre: Codable {
    let genreId: String
    let name: String
    let url: String
}
