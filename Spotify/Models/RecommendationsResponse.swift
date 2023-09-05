//
//  RecommendationsResponse.swift
//  Spotify
//
//  Created by Begüm Tüzüner on 18.07.2023.
//

import Foundation

struct RecommendationsResponse: Codable{
    let tracks: [AudioTrack]
}

