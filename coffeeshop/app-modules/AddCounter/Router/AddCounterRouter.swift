//
//  AddCounterRouter.swift
//  coffeeshop
//
//  Created by Cesar Miguel Chavez on 02/03/21.
//

import Foundation

class AddCounterRouter: AddCounterRouterProtocol {
    
    class func createModule(addCounterView: AddCounterViewController) {
        
        let presenter: AddCounterPresenterProtocol & AddCounterOutputInteractorProtocol = AddCounterPresenter()
        addCounterView.presenter = presenter
        addCounterView.presenter?.router = AddCounterRouter()
        addCounterView.presenter?.view = addCounterView
        addCounterView.presenter?.interactor = AddCounterInteractor()
        addCounterView.presenter?.interactor?.presenter = presenter
        
    }
}
