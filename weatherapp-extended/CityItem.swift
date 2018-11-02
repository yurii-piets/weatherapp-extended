import Foundation

struct CityItem: Decodable {
    let title: String?
    let id: Int?
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case id = "woeid"
    }
}
