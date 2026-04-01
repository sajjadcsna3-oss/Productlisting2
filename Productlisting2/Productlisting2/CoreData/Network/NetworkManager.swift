//
// NetworkManager.swift
// ShopApp
//
// Created by Mac Mini on 26/03/2026.
//

import Foundation
import Combine

final class NetworkManager: NetworkService {
private let baseURL = "https://fakestoreapi.com"
func request<T: Decodable>(endpoint: APIEndpoint) -> AnyPublisher<T, Error> {
    guard var components = URLComponents(string: baseURL + endpoint.path) else {
        return Fail(error: URLError(.badURL))
            .eraseToAnyPublisher()
    }

    components.queryItems = endpoint.queryItems.isEmpty ? nil : endpoint.queryItems

    guard let url = components.url else {
        return Fail(error: URLError(.badURL))
            .eraseToAnyPublisher()
    }

    print("✅ Request URL:", url.absoluteString)

    var request = URLRequest(url: url)
    request.httpMethod = endpoint.method.rawValue
    request.timeoutInterval = 30

    return URLSession.shared.dataTaskPublisher(for: request)
        .tryMap { output in
            guard let response = output.response as? HTTPURLResponse else {
                throw NSError(
                    domain: "NetworkError",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Invalid server response."]
                )
            }

            print("✅ Status Code:", response.statusCode)

            guard 200...299 ~= response.statusCode else {
                let rawResponse = String(data: output.data, encoding: .utf8) ?? "No response body"
                print("❌ Server Response Body:", rawResponse)

                throw NSError(
                    domain: "NetworkError",
                    code: response.statusCode,
                    userInfo: [NSLocalizedDescriptionKey: "Server returned an error."]
                )
            }

            let rawJSON = String(data: output.data, encoding: .utf8) ?? "Invalid JSON"
            print("✅ Raw JSON:", rawJSON)

            return output.data
        }
        .decode(type: T.self, decoder: JSONDecoder())
        .mapError { error in
            print("❌ Decode/Network Error:", error.localizedDescription)
            return error
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
}
}
