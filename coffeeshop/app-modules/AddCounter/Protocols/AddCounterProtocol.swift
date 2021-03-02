//
//  AddCounterProtocol.swift
//  coffeeshop
//
//  Created by Cesar Miguel Chavez on 02/03/21.
//

import Foundation

import UIKit

protocol AddCounterProtocol: class {
    //PRESENTER -> VIEW
    func responseAddCounter()
    func showViewErrorInServer()
}


protocol AddCounterPresenterProtocol: class {
    //View -> Presenter
    
    var interactor: AddCounterInteractorProtocol? {get set}
    var view: AddCounterProtocol? {get set}
    var router: AddCounterRouterProtocol? {get set}
    
    func viewDidLoad()
    func addCounter(name: String)

}

protocol AddCounterInteractorProtocol: class {
    //Presenter -> Interactor
    var presenter: AddCounterOutputInteractorProtocol? {get set}
    func requestAddCounter(name: String)
}

protocol AddCounterOutputInteractorProtocol: class {
    //Interactor -> PresenterOutput
    
    func responseAddCounter()
    func showViewErrorInServer()
}


protocol AddCounterRouterProtocol: class {
    static func createModule(addCounterView: AddCounterViewController)
}
