//
//  FilterOption.swift
//  Productlisting2
//
//  Created by Mac Mini on 02/04/2026.
//
import Foundation

enum FilterOption: Identifiable, Equatable {
    case all
    case category(String)
    case priceLowToHigh
    case priceHighToLow

    var id: String {
        switch self {
        case .all:
            return "all"
        case .category(let value):
            return value
        case .priceLowToHigh:
            return "low"
        case .priceHighToLow:
            return "high"
        }
    }

    var title: String {
        switch self {
        case .all:
            return "All"
        case .category(let value):
            return value.capitalized
        case .priceLowToHigh:
            return "Price: Low to High"
        case .priceHighToLow:
            return "Price: High to Low"
        }
    }
}
