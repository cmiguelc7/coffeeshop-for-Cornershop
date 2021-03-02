//
//  CounterListInteractor.swift
//  coffeeshop
//
//  Created by Cesar Miguel Chavez on 01/03/21.
//

import Foundation
import UIKit

class CounterListInteractor: CounterListInteractorProtocol {
    
    var presenter: CounterListOutputInteractorProtocol?
    
    func requestCounterList(from view: UIViewController) {
        print("GetCounterList")
    }
    
}
