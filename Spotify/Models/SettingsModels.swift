//
//  SettingsModels.swift
//  Spotify
//
//  Created by Begüm Tüzüner on 17.07.2023.
//

import Foundation

struct Section {
    let title: String
    let options: [Option]
}

struct Option {
    let title: String
    let handler: () -> Void
}
