//
//  SearchResult.swift
//  Spotify
//
//  Created by Begüm Tüzüner on 26.07.2023.
//

import Foundation

enum SearchResult {
    case artist(model: Artist)
    case album(model: Album)
    case track(model: AudioTrack)
    case playlist(model: Playlist)
}
