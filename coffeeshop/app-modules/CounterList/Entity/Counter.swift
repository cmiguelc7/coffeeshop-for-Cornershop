//
//  Counter.swift
//  coffeeshop
//
//  Created by Cesar Miguel Chavez on 01/03/21.
//

import Foundation

struct Counter: Equatable {
    
    var id:String!
    var title:String!
    var count:Int!
    
    init(id:String!, title:String!, count:Int! = 0){
        self.id = id
        self.title = title
        self.count = count
    }
    
}
