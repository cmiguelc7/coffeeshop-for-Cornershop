//
//  CounterListProtocol.swift
//  coffeeshop
//
//  Created by Cesar Miguel Chavez on 01/03/21.
//

import UIKit

protocol CounterListProtocol: class {
    //PRESENTER -> VIEW
    func receiveCounterList(CounterLists:Array<Counter>)
    func showViewErrorServer()
}


protocol CounterListPresenterProtocol: class {
    //View -> Presenter
    
    var interactor: CounterListInteractorProtocol? {get set}
    var view: CounterListProtocol? {get set}
    var router: CounterListRouterProtocol? {get set}
    
    func viewDidLoad()
    func getCounterList()

}

protocol CounterListInteractorProtocol: class {
    //Presenter -> Interactor
    var presenter: CounterListOutputInteractorProtocol? {get set}
    func requestCounterList(from view: UIViewController)
}

protocol CounterListOutputInteractorProtocol: class {
    //Interactor -> PresenterOutput
    
    func receiveCounterList(counterLists: Array<Counter>)
    func showViewErrorServer()
}


protocol CounterListRouterProtocol: class {
    static func createModule(counterListView: CounterListViewController)
}
