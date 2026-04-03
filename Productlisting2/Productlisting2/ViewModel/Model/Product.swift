import Foundation

struct ProductListResponse: Codable {
    let products: [Product]
    let total: Int
    let skip: Int
    let limit: Int
}

struct Product: Codable, Identifiable, Equatable {
    let id: Int
    let title: String
    let description: String
    let category: String
    let price: Double
    let thumbnail: String
    let images: [String]

    var isFavorite: Bool = false

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case category
        case price
        case thumbnail
        case images
    }

    init(
        id: Int,
        title: String,
        description: String,
        category: String,
        price: Double,
        thumbnail: String,
        images: [String],
        isFavorite: Bool = false
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.price = price
        self.thumbnail = thumbnail
        self.images = images
        self.isFavorite = isFavorite
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        category = try container.decode(String.self, forKey: .category)
        thumbnail = try container.decode(String.self, forKey: .thumbnail)
        images = try container.decodeIfPresent([String].self, forKey: .images) ?? []

        if let doublePrice = try? container.decode(Double.self, forKey: .price) {
            price = doublePrice
        } else if let intPrice = try? container.decode(Int.self, forKey: .price) {
            price = Double(intPrice)
        } else {
            price = 0
        }

        isFavorite = false
    }
}
