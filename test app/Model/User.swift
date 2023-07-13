import Foundation

struct User: Codable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let company: Company
}

struct Company: Codable {
    let name: String
}
