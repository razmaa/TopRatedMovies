



import Foundation

struct TopRatedResponse: Decodable {
    let results: [TVSeries]
}

struct TVSeries: Decodable, Hashable {
    let id: Int
    let name: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    
    private enum CodingKeys: String, CodingKey {
        case id, name, overview
        case posterPath   = "poster_path"
        case backdropPath = "backdrop_path"
    }
}
