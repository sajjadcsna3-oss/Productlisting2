//
//  ProductEndpoint.swift
//  ShopApp
//
import Foundation

enum ProductEndpoint: APIEndpoint {
    case products
    case productDetail(id: Int)
    case categories

    var path: String {
        switch self {
        case .products:
            return "/products"
        case .productDetail(let id):
            return "/products/\(id)"
        case .categories:
            return "/products/categories"
        }
    }

    var method: HTTPMethod {
        .get
    }

    var queryItems: [URLQueryItem] {
        []
    }
}
