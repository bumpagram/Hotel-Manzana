//  Model.swift
//  Hotel Manzana
//  Created by .b[u]mpagram  on 4/10/23.
//
import Foundation

struct Registration {
    var firstName: String
    var lastName: String
    var emailAddress: String

    var checkInDate: Date
    var checkOutDate: Date
    var numberOfAdults: Int
    var numberOfChildren: Int

    var wifi: Bool
    var roomType: RoomType
}


struct RoomType: Equatable {
    var id: Int
    var name: String
    var shortName: String
    var price: Int
 
    static func ==(left: RoomType, right: RoomType) -> Bool {
        return left.id == right.id
    }
}
