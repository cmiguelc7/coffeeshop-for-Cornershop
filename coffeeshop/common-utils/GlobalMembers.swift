//
//  GlobalMembers.swift
//  kokatu
//
//  Created by Cesar Miguel Chavez on 8/27/19.
//  Copyright © 2019 Heanan. All rights reserved.
//

import Foundation

struct Constants {
    
    static var baseURL = "http://192.168.100.11:3000"    
    
}

enum Api:String {
    
    case GET_COUNTERS = "/api/v1/counters"
    case COUNTER = "/api/v1/counter"
    case INC_COUNTER = "/api/v1/counter/inc"
    case DEC_COUNTER = "/api/v1/counter/dec"
    
}
