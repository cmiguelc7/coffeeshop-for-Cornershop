//
//  AddCounterInteractor.swift
//  coffeeshop
//
//  Created by Cesar Miguel Chavez on 02/03/21.
//

import Foundation

class AddCounterInteractor: AddCounterInteractorProtocol {
    
    var presenter: AddCounterOutputInteractorProtocol?
    
    func requestAddCounter(name: String) {
        
        let stringURL = String(format: "%@%@", Constants.baseURL, Api.COUNTER.rawValue)

        guard let url = URL(string: stringURL) else {
                print("Error: cannot create URL")
                return
            }
            // Create the url request
            var request = URLRequest(url: url)
            request.httpMethod = "POST"            
            
            let parameterDictionary = ["title" : name]
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
                    return
            }
            
            request.httpBody = httpBody

            URLSession.shared.dataTask(with: request) { data, response, error in
                
                guard let data = data, error == nil else {
                    // check for fundamental networking error
                    print(" error = \(String(describing: error))")
                    self.presenter?.showViewErrorInServer()
                     return
                 }

                 if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    // check for http errors
                    self.presenter?.showViewErrorInServer()
                 }

                 do {
                     if let convertedJsonIntoArray = try JSONSerialization.jsonObject(with: data, options: []) as? NSArray {

                         if convertedJsonIntoArray.count > 0 {
                            self.presenter?.responseAddCounter()
                         }
                     }
                 }
                 catch let error as NSError {
                    print(error.localizedDescription)
                    self.presenter?.showViewErrorInServer()
                 }
                
           }.resume()
    }
}
