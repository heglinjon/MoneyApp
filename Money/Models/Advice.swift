//Created for Money in 2023
// Using Swift 5.0

import Foundation

struct Advice: Codable {
    var title: Double
    var description: String

    enum CodingKeys: String, CodingKey {
        case title = "Cancel Unused Subscriptions"
        case description = "Small numbers add up to big numbers! Review recurring charges and drop those you no longer use."
    }
}
