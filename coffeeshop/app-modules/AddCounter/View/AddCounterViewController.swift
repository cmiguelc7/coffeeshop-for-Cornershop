//
//  AddCounterViewController.swift
//  coffeeshop
//
//  Created by Cesar Miguel Chavez on 02/03/21.
//

import Foundation

import UIKit

class AddCounterViewController: UIViewController, AddCounterProtocol {
    
    @IBOutlet weak var containerViewTextFieldTitleCounter: UIView!
    @IBOutlet weak var textFieldTitleCounter: UITextField!
    @IBOutlet weak var labelExamples: UILabel!
    @IBOutlet weak var barButtonItemSave: UIBarButtonItem!
    
    var presenter:AddCounterPresenterProtocol?
    var ativityIndicatorToSave = UIActivityIndicatorView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configVIPER()
        cofingUI()
    }
    
    func configVIPER(){
        AddCounterRouter.createModule(addCounterView: self)
        presenter?.viewDidLoad()
    }
    
    func cofingUI(){
        
        //navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.largeTitleDisplayMode = .never
        
        containerViewTextFieldTitleCounter.layer.cornerRadius = 8.0
        textFieldTitleCounter.rightViewMode = .always
        textFieldTitleCounter.rightView = ativityIndicatorToSave
        
        let tapOpenExamples = UITapGestureRecognizer(target: self, action: #selector(actinHandlerOpenExamples(_:)))
        tapOpenExamples.numberOfTapsRequired = 1
        labelExamples.isUserInteractionEnabled = true
        labelExamples.addGestureRecognizer(tapOpenExamples)
    }
    
    @objc func actinHandlerOpenExamples(_ tap: UITapGestureRecognizer) {
        
        let examplesViewController = self.storyboard?.instantiateViewController(identifier: "examplesID") as! ExamplesViewController
        let navigationController = UINavigationController(rootViewController: examplesViewController)
        self.present(navigationController, animated: true, completion: nil)
        
    }
    
    @IBAction func actionHanderlCancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func actionHandlerSave(_ sender: Any) {
        initFlowAddCounter()
    }
    
    func initFlowAddCounter(){
        
        if textFieldTitleCounter.text == "" {
            showAlert(title: "Couldn't create the counter", message: "A name is necessary to be able to save the information.")
            return
        }
        
        if Reachability.isConnectedToNetwork(){
            
            barButtonItemSave.isEnabled = false
            ativityIndicatorToSave.startAnimating()
            let seconds = 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                // Put your code which should be executed with a delay here
                let nameCounter = self.textFieldTitleCounter.text
                self.presenter?.addCounter(name: nameCounter!)
            }
            
        }else{
            showAlertNoInternet()
        }
    }
    
    func showAlertNoInternet() {
        
        let alertController = UIAlertController(title: "Couldn't create the counters", message:"The internet connection appears to be offline.", preferredStyle: .alert)
        
        alertController.view.tintColor = UIColor.baseColorCounters()
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: {action in
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func responseAddCounter(){
        DispatchQueue.main.async {
            self.barButtonItemSave.isEnabled = true
            self.ativityIndicatorToSave.stopAnimating()
            self.textFieldTitleCounter.text = ""
            self.showAlertSavedCounter()
        }
    }
    
    func showViewErrorInServer() {
        DispatchQueue.main.async {
            self.tryAgainSaveTheCounter()
        }
    }
    
    
    func showAlert(title:String, message: String) {
        
        let alertController = UIAlertController(title: title, message:
        message, preferredStyle: .alert)
        
        alertController.view.tintColor = UIColor.baseColorCounters()
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: {action in
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertSavedCounter() {
        
        let alertController = UIAlertController(title: "Counter Saved", message:
        "The counter is Saved. Do you go to the list o create a new counter?", preferredStyle: .alert)
        
        alertController.view.tintColor = UIColor.baseColorCounters()
        
        alertController.addAction(UIAlertAction(title: "List Counters", style: .cancel, handler: {action in
            self.goToListCounters()
        }))
        
        alertController.addAction(UIAlertAction(title: "Create New", style: .default, handler: {action in
            print("Dismiss only")
        }))
        
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func goToListCounters(){
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: CounterListViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    func tryAgainSaveTheCounter(){
        self.barButtonItemSave.isEnabled = true
        self.ativityIndicatorToSave.stopAnimating()
        self.showAlert(title: "Couldn't create the counter", message: "There was a problem on the server, please try again later.")
    }
    
    
    
}
