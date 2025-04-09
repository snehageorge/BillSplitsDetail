//
//  BillDataModel.swift
//  BillSplitsDetail
//
//  Created by Sneha on 07/04/25.
//

struct Bill: Codable, Identifiable {
    var id: Int
    var shopName: String
    var foodImage: String
    var shopLogo: String
    var totalAmount: Double
    var date: String
    var userName: String
    var userImage: String
    var isPending: Bool
    var friends: [Friend]
}

struct Friend: Codable {
    var friendId: Int
    var name: String
    var amount: Double
    var userImage: String
    var isPaid: Bool
}

struct BillResponse: Codable {
    var bills: [Bill]
}
