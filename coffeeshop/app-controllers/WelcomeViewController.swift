//
//  ViewController.swift
//  coffeeshop
//
//  Created by Cesar Miguel Chavez on 01/03/21.
//

import UIKit

class WelcomeViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var buttonContinue: UIButton!
    
    @IBOutlet weak var tableViewWelcome: UITableView!
    
    var arrayDataWelcome:[NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        buttonContinue.layer.ApplySketchShadow(color: .black, alpha: 0.5, x: 0, y: 8, blur: 16, spread: 0, isCornerRadius: true)
        tableViewWelcome.delegate = self
        tableViewWelcome.dataSource = self
        
        arrayDataWelcome =  [
                                ["title":"Add almost anything","description":"Capture cups and lattes, frapuccinos, or anything else than can be counted.","image":"iconWAdd"],
                                ["title":"Count to self, or with anyone","description":"Others can view or make changes. There's no authentication API.","image":"iconWCount"],
                                ["title":"Count your thoughts","description":"Possibilities are literally endless","image":"iconWIdea"]
                            ]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    @IBAction func openListCounters(_ sender: Any) {
        let countersTableViewController = self.storyboard?.instantiateViewController(identifier: "counterListID") as! CounterListViewController
        let navigationController = UINavigationController(rootViewController: countersTableViewController)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.modalTransitionStyle = .crossDissolve
        self.present(navigationController, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayDataWelcome.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 200
        }
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      
        let dicObject = arrayDataWelcome[indexPath.row]
        
        let title = dicObject.value(forKey: "title") as! String
        let description = dicObject.value(forKey: "description") as! String
        var image = dicObject.value(forKey: "image") as! String
        
        cell.textLabel?.text = title
        
        cell.detailTextLabel?.text = description
        cell.detailTextLabel?.numberOfLines = 5
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            image = image+"_ipad"
            cell.textLabel?.font = UIFont.systemFont(ofSize: 50.0)
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 33.0)
        }
        
        cell.imageView?.image = UIImage(named: image)
        
        let animation = AnimationFactory.makeMoveUpWithFade(rowHeight: cell.frame.height, duration: 0.7, delayFactor: 0.05)
        let animator = Animator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: tableView)
        
        return cell
        
    }
    
}

