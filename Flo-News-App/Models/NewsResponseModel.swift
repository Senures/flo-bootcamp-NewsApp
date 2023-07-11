//
//  NewsResponseModel.swift
//  Flo-News-App
//
//  Created by Semanur Eserler on 25.06.2023.
//

import Foundation

struct NewsResponseModel: Codable {
    var status: String?
    var totalResults: Int?
    var articles: [Article]?
}

// MARK: - Article
struct Article: Codable {
    var source: Source?
    var author, title, description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
}

// MARK: - Source
struct Source: Codable {
    var id: String?
    var name: String?
}
