//
//  NetworkError.swift
//  Productlisting2
//
//  Created by Mac Mini on 02/04/2026.
//
import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case serverError(statusCode: Int, message: String)
    case decodingError
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .invalidResponse:
            return "Invalid server response."
        case .serverError(let statusCode, let message):
            return "Server error (\(statusCode)): \(message)"
        case .decodingError:
            return "Failed to decode server response."
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
