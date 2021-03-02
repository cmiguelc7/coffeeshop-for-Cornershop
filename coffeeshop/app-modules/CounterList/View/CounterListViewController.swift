//
//  CounterListViewController.swift
//  coffeeshop
//
//  Created by Cesar Miguel Chavez on 01/03/21.
//

import Foundation
import UIKit

enum typeOpenAction:Int {
    case CreateCounter = 1
    case Retry = 2
}

class CounterListViewController: UIViewController, UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate, ErrorInformationDelegate, CounterListProtocol {
    
    func updateSearchResults(for searchController: UISearchController) {
        print("updateSearchResults")
    }
    
    var presenter:CounterListPresenterProtocol?
    
    @IBOutlet weak var containerToolBar: UIView!
    
    @IBOutlet weak var tableViewCounters: UITableView!
    
    //BAR BUTTON ITEMS NAVIGATIONCONTROLLER --------------------------
    var barButtonItemEdit = UIBarButtonItem()
    var barButtonItemDone = UIBarButtonItem()
    @IBOutlet weak var barButtonItemSelectAll: UIBarButtonItem!
    
    //BAR BUTTON ITEMS  TOOL BAR---------------------------------------
    @IBOutlet weak var toolBarCounters: UIToolbar!
    
    @IBOutlet weak var barButtonItemTrash: UIBarButtonItem!
    
    var barButtonItemAdd = UIBarButtonItem()
    var barButtonItemShare = UIBarButtonItem()
    
    @IBOutlet weak var labelCountedItems: UILabel!
    
    
    var arrayLocalCounterList:[Counter] = []
    var filteredLocalCounterList:[Counter] = []
    var searchController = UISearchController()
    var isSearchingInfo: Bool = false
    var ativityIndicatorLoadCounters = UIActivityIndicatorView()
    
    var errorInformationVC:ErrorInformation!
    var GLTypeButtonAction:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configVIPER()
        configUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        initFlowCounters();
    }
    
    func configVIPER(){
        CounterListRouter.createModule(counterListView: self)
        presenter?.viewDidLoad()
    }
    
    func configUI(){
        
        addErrorInformation()
        
        ativityIndicatorLoadCounters.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        tableViewCounters.backgroundView = ativityIndicatorLoadCounters
        
        tableViewCounters.delegate = self
        tableViewCounters.dataSource = self
        tableViewCounters.allowsMultipleSelectionDuringEditing = true
        tableViewCounters.tableFooterView = .init()
        tableViewCounters.contentInsetAdjustmentBehavior = .always
        tableViewCounters.refreshControl = .init()
        //tableViewCounters.refreshControl?.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        
        //tableViewCounters.addSubview(refreshControl)
        
        searchBar()
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.navigationBar.sizeToFit()
        }
        
        //BAR BUTTON ITEMS
        
        //barButtonItemDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(actionHandlerDone))
        barButtonItemDone.tintColor = UIColor.baseColorCounters()
        
        //barButtonItemEdit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(actionHandlerEdit))
        barButtonItemEdit.tintColor = UIColor.baseColorCounters()
        self.navigationItem.setLeftBarButtonItems([barButtonItemEdit], animated: true)
        self.barButtonItemEdit.isEnabled = false
        
        self.barButtonItemTrash.isEnabled = false
        self.barButtonItemTrash.tintColor = .clear
        
        self.barButtonItemSelectAll.isEnabled = false
        self.barButtonItemSelectAll.tintColor = .clear
        
        //BAR BUTTON ITEM SHARE
        let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "iconShare"), for: .normal)
        //button.addTarget(self, action: #selector(self.shareInfo), for: UIControl.Event.touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        button.backgroundColor = containerToolBar.backgroundColor
        barButtonItemShare = UIBarButtonItem(customView: button)
        
        //barButtonItemAdd = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(actionHandlerAdd))
        barButtonItemAdd.tintColor = UIColor.baseColorCounters()
        
        var toolbarItems = toolBarCounters.items
        toolbarItems![4] = barButtonItemAdd
        toolBarCounters.setItems(toolbarItems, animated: true)
        
        labelCountedItems.text = ""
        
    }
    
    func searchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.definesPresentationContext = true
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = UIColor.baseColorCounters()
        
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.placeholder = "Search"
        navigationItem.hidesSearchBarWhenScrolling = false
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.title = "Counters"
        navigationController?.navigationBar.backgroundColor = .white
    }
    
    //MARK: FLOW COUNTERS
    func initFlowCounters(){
        
        //errorInformationVC.view.isHidden = true
        
        if Reachability.isConnectedToNetwork(){
            print("vamos a pedir la informacion")
            ativityIndicatorLoadCounters.startAnimating()
            presenter?.getCounterList()
        }else{
            //showViewNoInternet()
        }
    }
    
    func receiveCounterList(arrayCounterList: Array<Counter>) {
        
        print("receiveCounterList")
        
        //self.filteredLocalCounterList.removeAll()
        self.arrayLocalCounterList.removeAll()
        
        arrayLocalCounterList = arrayCounterList
        
        DispatchQueue.main.async {
            
            self.barButtonItemEdit.isEnabled = true
            self.barButtonItemEdit.tintColor = UIColor.baseColorCounters()
            
            self.tableViewCounters.refreshControl?.endRefreshing()
            self.ativityIndicatorLoadCounters.stopAnimating()
            self.tableViewCounters.reloadData()
            //self.totalItemsAndCalculatedTimes()
        }
        
    }
    
    func showViewErrorInServer() {
        DispatchQueue.main.async {
            self.showViewErrorInformationInServer()
            self.labelCountedItems.text = ""
            self.tableViewCounters.refreshControl?.endRefreshing()
        }
    }
    
    func showViewErrorNoResults() {
        DispatchQueue.main.async {
            self.showViewErrorInformationNoResults()
            self.labelCountedItems.text = ""
            self.tableViewCounters.refreshControl?.endRefreshing()
        }
    }
    
    
    //MARK: TABLE VIEW DELEGATES
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayLocalCounterList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "identifierCounterCell", for: indexPath) as! CounterCell
      
        let counter = arrayLocalCounterList[indexPath.row]
        cell.configure(counter: counter, viewController: self)

        return cell
        
    }
    
    //MARK: UI ERROR SERVER
    func touchErrorInformationAction() {
        switch GLTypeButtonAction {
            case typeOpenAction.CreateCounter.rawValue:
                //openCreateCounter()
                print("openCreateCounter")
            case typeOpenAction.Retry.rawValue:
                initFlowCounters()
        default:
            print("Vientos")
        }
    }
    
    func addErrorInformation(){
        
        errorInformationVC = (self.storyboard?.instantiateViewController(withIdentifier: "errorInformationID") as! ErrorInformation)
        
        addChild(errorInformationVC)
        
        errorInformationVC.delegate = self
        errorInformationVC.stringIcon = "errorNoResults"
        errorInformationVC.stringTitle = "-"
        errorInformationVC.stringeDescription = "-"
        errorInformationVC.stringButton = "-"
        
        errorInformationVC.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: self.view.frame.size.height-85)
        
        self.view.addSubview(errorInformationVC.view)
        errorInformationVC.view.isHidden = true
    }
    
    func showViewErrorInformationNoResults(){
        
        errorInformationVC.stringIcon = "errorNoResults"
        errorInformationVC.stringTitle = "No counters yet"
        errorInformationVC.stringeDescription = "When I started counting my blessings, my whole life turned around.\n--Whillie Nelson"
        errorInformationVC.stringButton = "Create a counter"
        errorInformationVC.setStrings()
        
        errorInformationVC.view.isHidden = false;
        
        GLTypeButtonAction = typeOpenAction.CreateCounter.rawValue
        
        self.labelCountedItems.text = ""
        self.tableViewCounters.refreshControl?.endRefreshing()
        
        self.barButtonItemEdit.isEnabled = false
        
    }
    
    func showViewErrorInformationInServer(){
        
        errorInformationVC.stringIcon = "errorServer"
        errorInformationVC.stringTitle = "Couldn't load the counters"
        errorInformationVC.stringeDescription = "There was a problem on the server, please try again later."
        errorInformationVC.stringButton = "Retry"
        errorInformationVC.setStrings()
        
        errorInformationVC.view.isHidden = false;
        
        GLTypeButtonAction = typeOpenAction.Retry.rawValue
        
        self.labelCountedItems.text = ""
        self.tableViewCounters.refreshControl?.endRefreshing()
        
        self.barButtonItemEdit.isEnabled = false
        
    }
    
    func showViewErrorInformationNoInternet(){
        
        errorInformationVC.stringIcon = "errroNoInternet"
        errorInformationVC.stringTitle = "Couldn't load the counters"
        errorInformationVC.stringeDescription = "The internet connection appears to be offline."
        errorInformationVC.stringButton = "Retry"
        errorInformationVC.setStrings()
        
        errorInformationVC.view.isHidden = false;
        
        GLTypeButtonAction = typeOpenAction.Retry.rawValue
        
        self.labelCountedItems.text = ""
        self.tableViewCounters.refreshControl?.endRefreshing()
        
        self.barButtonItemEdit.isEnabled = false
        
    }
    
    
}
