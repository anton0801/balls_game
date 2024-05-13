import Foundation
import SwiftyJSON

struct AwardItem: Identifiable {
    let name: String
    let reward: Int
    let id: String = UUID().uuidString
}

struct BallsQuestDtta: Codable {
    var appsflyer: JSON
    var facebook_deeplink: String
}

struct BallsQuestDtta2: Decodable {
    var client_id: String
    var session_id: String
    var offer_id: Int?
    var response: String?
    var message: String?
    var product: String?
    var saved_url: Bool?
}

extension Dictionary {
    func jsonData() throws -> Data {
        try JSONSerialization.data(withJSONObject: self)
    }
}
