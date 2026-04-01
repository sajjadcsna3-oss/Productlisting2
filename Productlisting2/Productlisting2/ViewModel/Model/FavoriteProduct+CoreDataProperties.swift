//
// FavoriteProduct+CoreDataProperties.swift
// ShopApp
//
// Created by Mac Mini on 26/03/2026.
//
import Foundation
import CoreData

extension FavoriteProduct {
@nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteProduct> {
NSFetchRequest<FavoriteProduct>(entityName: "FavoriteProduct")
}
@NSManaged public var id: Int64
@NSManaged public var title: String
@NSManaged public var price: Double
@NSManaged public var productDescription: String
@NSManaged public var category: String
@NSManaged public var image: String
@NSManaged public var ratingRate: Double
@NSManaged public var ratingCount: Int64
}

extension FavoriteProduct {
static func from(product: Product, context: NSManagedObjectContext) -> FavoriteProduct {
let favorite = FavoriteProduct(context: context)
favorite.id = Int64(product.id)
favorite.title = product.title
favorite.price = product.price
favorite.productDescription = product.description
favorite.category = product.category
favorite.image = product.image
favorite.ratingRate = product.rating.rate
favorite.ratingCount = Int64(product.rating.count)
return favorite
}

func toProduct() -> Product {
    Product(
        id: Int(id),
        title: title,
        price: price,
        description: productDescription,
        category: category,
        image: image,
        rating: Product.Rating(rate: ratingRate, count: Int(ratingCount))
    )
}
}
