//
//  CounterListRouter.swift
//  coffeeshop
//
//  Created by Cesar Miguel Chavez on 01/03/21.
//

import Foundation

class CounterListRouter: CounterListRouterProtocol {
    
    class func createModule(counterListView: CounterListViewController) {
        
        let presenter: CounterListPresenterProtocol & CounterListOutputInteractorProtocol = CounterListPresenter()
        counterListView.presenter = presenter
        counterListView.presenter?.router = CounterListRouter()
        counterListView.presenter?.view = counterListView
        counterListView.presenter?.interactor = CounterListInteractor()
        counterListView.presenter?.interactor?.presenter = presenter
        
    }
}
