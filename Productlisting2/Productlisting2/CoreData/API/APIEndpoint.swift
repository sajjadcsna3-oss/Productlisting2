//
//  APIEndpoint.swift
//  ShopApp
//
//  Created by Mac Mini on 26/03/2026.
import Foundation

protocol APIEndpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem] { get }
}
