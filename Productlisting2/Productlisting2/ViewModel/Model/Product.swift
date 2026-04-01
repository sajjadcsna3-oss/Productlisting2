//
// Product.swift
// ShopApp
//
// Created by Mac Mini on 26/03/2026.
//

import Foundation

struct Product: Codable, Identifiable, Equatable {
let id: Int
let title: String
let price: Double
let description: String
let category: String
let image: String
let rating: Rating
var isFavorite: Bool = false
struct Rating: Codable, Equatable {
    let rate: Double
    let count: Int
}

enum CodingKeys: String, CodingKey {
    case id
    case title
    case price
    case description
    case category
    case image
    case rating
}

init(
    id: Int,
    title: String,
    price: Double,
    description: String,
    category: String,
    image: String,
    rating: Rating,
    isFavorite: Bool = false
) {
    self.id = id
    self.title = title
    self.price = price
    self.description = description
    self.category = category
    self.image = image
    self.rating = rating
    self.isFavorite = isFavorite
}
}
