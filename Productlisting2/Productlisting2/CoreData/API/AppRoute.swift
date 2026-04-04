//
//  AppRoute.swift
//  Productlisting2
//
//  Created by Mac Mini on 02/04/2026.
//
import Foundation

enum AppRoute: Hashable {
    case productList
    case productDetail(id: Int)
    case favorites
}
