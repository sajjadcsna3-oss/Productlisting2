import Foundation
import CoreData

extension FavoriteProduct {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteProduct> {
        return NSFetchRequest<FavoriteProduct>(entityName: "FavoriteProduct")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var price: Double
    @NSManaged public var productDescription: String?
    @NSManaged public var category: String?
    @NSManaged public var image: String?
}

extension FavoriteProduct {
    static func from(product: Product, context: NSManagedObjectContext) -> FavoriteProduct {
        let favorite = FavoriteProduct(context: context)
        favorite.id = Int64(product.id)
        favorite.title = product.title
        favorite.price = product.price
        favorite.productDescription = product.description
        favorite.category = product.category
        favorite.image = product.thumbnail
        return favorite
    }
}
extension FavoriteProduct {
    func toProduct() -> Product {
        Product(
            id: Int(id),
            title: title ?? "",
            description: productDescription ?? "",
            category: category ?? "",
            price: price,
            thumbnail: image ?? "",
            images: image?.isEmpty == false ? [image!] : [],
            isFavorite: true
        )
    }
}
