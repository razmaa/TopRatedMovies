


import Foundation

final class TMDBClient {
    
    static let shared = TMDBClient()   
    
    private init() {}
    
    func fetchTopRated(page: Int = 1,
                       language: String = "en-US") async throws -> [TVSeries] {
        
        guard let url = buildURL(page: page, language: language) else {
            throw TMDBError.badURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpRes = response as? HTTPURLResponse else {
                throw TMDBError.noData
            }
            
            guard 200..<300 ~= httpRes.statusCode else {
                throw TMDBError.badStatusCode(httpRes.statusCode)
            }
            
            let decoded = try JSONDecoder().decode(TopRatedResponse.self, from: data)
            return decoded.results

        } catch let decodingError as DecodingError {
            throw TMDBError.decoding(decodingError)
        } catch let error {
            throw TMDBError.network(error)
        }

    }
    
    // MARK: URL Assembler
    private func buildURL(page: Int,
                          language: String) -> URL? {
        var comps = URLComponents(string: TMDB.apiBaseURL + "/top_rated")
        comps?.queryItems = [
            .init(name: "api_key",  value: TMDB.apiKey),
            .init(name: "language", value: language),
            .init(name: "page",     value: "\(page)")
        ]
        return comps?.url
    }
}


enum TMDBError: Error, LocalizedError {
    case badURL
    case badStatusCode(Int)
    case noData
    case decoding(Error)
    case network(Error)
    
    var errorDescription: String? {
        switch self {
        case .badURL:              return "Unable to create request URL."
        case .badStatusCode(let c):return "Server responded with status-code \(c)."
        case .noData:              return "No data in response."
        case .decoding:            return "Failed to decode JSON."
        case .network(let e):      return e.localizedDescription
        }
    }
}
