//
//  Item.swift
//  LootLogger
//
//  Created by Adrian Lesniak on 20/02/2021.
//

import UIKit

class Item: Equatable, Codable {
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.name == rhs.name
                    && lhs.serialNumber == rhs.serialNumber
                    && lhs.valueInDollars == rhs.valueInDollars
                    && lhs.dateCreated == rhs.dateCreated
                    && lhs.isFavourite == rhs.isFavourite
    }
    
    var name: String
    var valueInDollars: Int
    var serialNumber: String?
    var dateCreated: Date
    var isFavourite: Bool
    var itemKey: String
    
    init(name: String, valueInDollars: Int, serialNumber: String?) {
        self.name = name
        self.valueInDollars = valueInDollars
        self.serialNumber = serialNumber
        self.dateCreated = Date()
        self.isFavourite = false
        self.itemKey = UUID().uuidString
    }
    
    convenience init(random: Bool = false) {
        self.init(name: "Default", valueInDollars: Int.random(in: 1..<100), serialNumber: "4632478")
    }

}
