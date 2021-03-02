//
//  CounterListPresenter.swift
//  coffeeshop
//
//  Created by Cesar Miguel Chavez on 01/03/21.
//

import UIKit

class CounterListPresenter: CounterListPresenterProtocol {
    
    var router: CounterListRouterProtocol?
    var view: CounterListProtocol?
    var interactor: CounterListInteractorProtocol?
    var presenter: CounterListPresenterProtocol?
    
    func viewDidLoad() { }
    
    func getCounterList() {
        interactor?.requestCounterList(from: view as! UIViewController)
    }
        
}

extension CounterListPresenter: CounterListOutputInteractorProtocol {
    
    func receiveCounterList(arrayCounterList: Array<Counter>) {
        view?.receiveCounterList(arrayCounterList: arrayCounterList)
    }
    
    func showViewErrorInServer() {
        self.view?.showViewErrorInServer()
    }
    
    func showViewErrorNoResults() {
        self.view?.showViewErrorNoResults()
    }

}
