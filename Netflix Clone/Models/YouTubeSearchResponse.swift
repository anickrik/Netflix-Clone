//
//  YouTubeSearchResponse.swift
//  Netflix Clone
//
//  Created by Rishi on 11/01/23.
//

import Foundation

struct YouTubeSearchResponse: Codable {
    var items: [Item]
}

// MARK: - Item
struct Item: Codable {
    var kind, etag: String?
    var id: ID?
}

// MARK: - ID
struct ID: Codable {
    var kind, videoID: String?
    
    enum CodingKeys: String, CodingKey {
        case kind
        case videoID = "videoId"
    }
}
