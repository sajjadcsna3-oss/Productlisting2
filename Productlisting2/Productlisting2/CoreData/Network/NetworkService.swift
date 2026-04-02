//
//  NetworkService.swift
//  ShopApp
//
//
// NetworkService.swift
// ShopApp
//
// Created by Mac Mini on 26/03/2026.
//
import Foundation
import Combine

protocol NetworkService {
    func request<T: Codable>(endpoint: APIEndpoint) -> AnyPublisher<T, NetworkError>
}
