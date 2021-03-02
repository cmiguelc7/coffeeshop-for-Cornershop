//
//  CounterListViewController.swift
//  coffeeshop
//
//  Created by Cesar Miguel Chavez on 01/03/21.
//

import Foundation
import UIKit

class CounterListViewController: UIViewController, UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate, ErrorInformationDelegate, CounterListProtocol {
    
    func receiveCounterList(CounterLists: Array<Counter>) {
        print("receiveCounterList")
    }
    
    func showViewErrorServer() {
        print("showViewErrorServer")
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        print("updateSearchResults")
    }
    
    func touchErrorInformationAction() {
        print("touchErrorInformationAction")
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
    
    
    var arrayData:[Counter] = []
    var filteredTableData:[Counter] = []
    var searchController = UISearchController()
    var isSearchingInfo: Bool = false
    var ativityIndicatorLoadCounters = UIActivityIndicatorView()
    
    var errorInformationVC:ErrorInformation!
    var GLTypeButtonAction:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        //initFlowCounters();
    }
    
    func configVIPER(){
        //BrastlewarkRouter.createModule(BrastlewarkRef: self)
        presenter?.viewDidLoad()
    }
    
    func configUI(){
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      
        return cell
        
    }
    
}
