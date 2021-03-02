//
//  AddCounterPresenter.swift
//  coffeeshop
//
//  Created by Cesar Miguel Chavez on 02/03/21.
//

import UIKit

class AddCounterPresenter: AddCounterPresenterProtocol {
    
    var router: AddCounterRouterProtocol?
    var view: AddCounterProtocol?
    var interactor: AddCounterInteractorProtocol?
    var presenter: AddCounterPresenterProtocol?
    
    func viewDidLoad() { }
    
    func addCounter(name: String) {
        interactor?.requestAddCounter(name: name)
    }
        
}

extension AddCounterPresenter: AddCounterOutputInteractorProtocol {
    
    func responseAddCounter() {
        view?.responseAddCounter()
    }
    
    func showViewErrorInServer() {
        self.view?.showViewErrorInServer()
    }

}
