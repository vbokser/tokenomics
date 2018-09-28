//
//  Token.swift
//  Tokenomics
//
//  Created by Vitaly Bokser on 7/25/18.
//  Copyright © 2018 Vitaly Bokser. All rights reserved.
//

import Foundation

class Token: NSObject
{
    var name : String
    var id: String
    var price: Double
    var marketCap: Double
    
    init(name: String, price: Double, marketCap: Double) {
        self.name = name
        self.id = "0"
        self.price = price
        self.marketCap = marketCap
    }
}
