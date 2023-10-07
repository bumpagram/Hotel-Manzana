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
 
    // func for protocol implementation
    static func ==(left: RoomType, right: RoomType) -> Bool {
        return left.id == right.id
    }
    
    static var all: [RoomType] { // массив с всеми комнатами в отеле, статик чтобы глобал константу не делать
        return [
        RoomType(id: 0, name: "Two queens", shortName: "2Q", price: 179),
        RoomType(id: 1, name: "One King", shortName: "K", price: 209),
        RoomType(id: 2, name: "Penthouse suite", shortName: "PHS", price: 309)
        
        ]
    }
}


