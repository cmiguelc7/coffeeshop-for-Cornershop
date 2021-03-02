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
        
        let stringURL = String(format: "%@%@", Constants.baseURL, Api.GET_COUNTERS.rawValue)

        guard let url = URL(string: stringURL) else {
                print("Error: cannot create URL")
                return
            }
            // Create the url request
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Accept")

            URLSession.shared.dataTask(with: request) { data, response, error in
                
                guard let data = data, error == nil else {
                    // check for fundamental networking error
                     //print("error=\(String(describing: error))")
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
                            print(convertedJsonIntoArray)
                            var arrayResultCounterList:[Counter] = []
                            
                            for item in convertedJsonIntoArray {
                                
                                let dicData = item as! NSDictionary
                                let id      = dicData.value(forKey: "id") as! String
                                let title   = dicData.value(forKey: "title") as! String
                                let count   = dicData.value(forKey: "count") as! Int
                                
                                arrayResultCounterList.append(Counter(id: id, title: title, count: count))
                                self.presenter?.receiveCounterList(arrayCounterList: arrayResultCounterList)
                            }
                            
                         } else {
                            self.presenter?.showViewErrorNoResults()
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
