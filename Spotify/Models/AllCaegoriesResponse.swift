//
//  AllCaegoriesResponse.swift
//  Spotify
//
//  Created by Begüm Tüzüner on 26.07.2023.
//

import Foundation

struct AllCategoriesResponse: Codable {
    let categories: Categories
}
struct Categories: Codable {
    let items: [Category]
}
struct Category: Codable {
    let id: String
    let name: String
    let icons: [APIImage]
}
