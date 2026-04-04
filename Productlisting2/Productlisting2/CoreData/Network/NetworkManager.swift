import Foundation
import Combine

final class NetworkManager: NetworkService {
    private let baseURL = "https://dummyjson.com"
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func request<T: Codable>(endpoint: APIEndpoint) -> AnyPublisher<T, NetworkError> {
        guard var components = URLComponents(string: baseURL + endpoint.path) else {
            return Fail(error: .invalidURL)
                .eraseToAnyPublisher()
        }

        components.queryItems = endpoint.queryItems.isEmpty ? nil : endpoint.queryItems

        guard let url = components.url else {
            return Fail(error: .invalidURL)
                .eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.timeoutInterval = 30
        request.httpBody = endpoint.body

        endpoint.headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        return session.dataTaskPublisher(for: request)
            .mapError { NetworkError.unknown($0) }
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse else {
                    throw NetworkError.invalidResponse
                }

                guard 200...299 ~= response.statusCode else {
                    let message = String(data: output.data, encoding: .utf8) ?? "Unknown server error"
                    throw NetworkError.serverError(
                        statusCode: response.statusCode,
                        message: message
                    )
                }

                return output.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if let networkError = error as? NetworkError {
                    return networkError
                } else if error is DecodingError {
                    return .decodingError
                } else {
                    return .unknown(error)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
