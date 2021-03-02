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
        
        searchBar()
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.navigationBar.sizeToFit()
        }
        
        //BAR BUTTON ITEMS
        
        barButtonItemDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(actionHandlerDone))
        barButtonItemDone.tintColor = UIColor.baseColorCounters()
        
        barButtonItemEdit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(actionHandlerEdit))
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
        button.addTarget(self, action: #selector(actionHandlerShareInfo), for: UIControl.Event.touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        button.backgroundColor = containerToolBar.backgroundColor
        barButtonItemShare = UIBarButtonItem(customView: button)
        
        barButtonItemAdd = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(actionHandlerAdd))
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
        
        errorInformationVC.view.isHidden = true
        
        if Reachability.isConnectedToNetwork(){
            print("vamos a pedir la informacion")
            ativityIndicatorLoadCounters.startAnimating()
            presenter?.getCounterList()
        }else{
            showViewErrorInformationNoInternet()
        }
    }
    
    func receiveCounterList(arrayCounterList: Array<Counter>) {
        
        self.filteredLocalCounterList.removeAll()
        self.arrayLocalCounterList.removeAll()
        
        arrayLocalCounterList = arrayCounterList
        
        DispatchQueue.main.async {
            
            self.barButtonItemEdit.isEnabled = true
            self.barButtonItemEdit.tintColor = UIColor.baseColorCounters()
            
            self.tableViewCounters.refreshControl?.endRefreshing()
            self.ativityIndicatorLoadCounters.stopAnimating()
            self.tableViewCounters.reloadData()
            self.totalItemsAndCalculatedTimes()
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
        
        if  (isSearchingInfo) {
            return filteredLocalCounterList.count
        } else {
            return arrayLocalCounterList.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "identifierCounterCell", for: indexPath) as! CounterCell
        
        if (isSearchingInfo) {
            
                let counterFilterData = filteredLocalCounterList[indexPath.row]
                cell.configure(counter: counterFilterData, viewController: self)

                return cell
        }else{
                let counter = arrayLocalCounterList[indexPath.row]
                cell.configure(counter: counter, viewController: self)

                return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath) {
        tableView.setEditing(true, animated: true)
    }
    
    func tableViewDidEndMultipleSelectionInteraction(_ tableView: UITableView) {
        print("\(#function)")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("Selected methid is called")
        validateShowHideTrashAndShareTotalItems()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //print("didDeselect methid is called")
        validateShowHideTrashAndShareTotalItems()
    }
    
    //MARK: SEARCH COUNTERS
    func updateSearchResults(for searchController: UISearchController) {
        
        if tableViewCounters.isEditing {
            actionHandlerDone()
        }
        
        filteredLocalCounterList.removeAll(keepingCapacity: false)
        
        guard let searchText = searchController.searchBar.text else {
            return
        }
        
        if searchText != "" {
            isSearchingInfo = true
            //searchController.obscuresBackgroundDuringPresentation = true
        }else{
            //searchController.obscuresBackgroundDuringPresentation = false
            isSearchingInfo = false
            tableViewCounters.reloadData()
        }
        
        for (index, counterObject) in arrayLocalCounterList.enumerated() {
            
            if arrayLocalCounterList[index].title.lowercased().contains(searchText.lowercased()) {
                filteredLocalCounterList.append(counterObject)
            }
            
        }
        
        let labelNoResults:UILabel = UILabel()
        labelNoResults.text = "No results"
        labelNoResults.textAlignment = .center
        labelNoResults.textColor = UIColor(red: 136/255.0, green: 139/255.0, blue: 144/255.0, alpha: 1.0)
        labelNoResults.font = UIFont(name: "System", size: 20)
        
        
        if filteredLocalCounterList.count == 0 && searchText != "" {
            
            tableViewCounters.backgroundView = labelNoResults
        }else{
            tableViewCounters.backgroundView = nil
        }
        
        
        tableViewCounters.reloadData()
        
        self.totalItemsAndCalculatedTimes()
    }
    
    func totalItemsAndCalculatedTimes() {
        
        var totalDataItems = arrayLocalCounterList.count
        var countedTimes = arrayLocalCounterList.map({$0.count}).reduce(0, +)
        var pluralItems = arrayLocalCounterList.count > 1 ? "s" : ""
        
        if isSearchingInfo {
            totalDataItems = filteredLocalCounterList.count
            countedTimes = filteredLocalCounterList.map({$0.count}).reduce(0, +)
            pluralItems = filteredLocalCounterList.count > 1 ? "s" : ""
        }
        
        let stringTotal = String(format: "%i item%@ · Counted %i times",totalDataItems,pluralItems,countedTimes)
        
        self.labelCountedItems.text = stringTotal
    
    }
    
    func validateShowHideTrashAndShareTotalItems(){
        
        if let selectedRows = tableViewCounters.indexPathsForSelectedRows {
            
            if selectedRows.count > 0{
                self.barButtonItemTrash.isEnabled = true
                self.barButtonItemTrash.tintColor = UIColor.baseColorCounters()
                
                var toolbarItems = toolBarCounters.items
                toolbarItems![4] = barButtonItemShare
                toolBarCounters.setItems(toolbarItems, animated: true)
                
                
                let stringSelected = String(format: "%i item%@ selected",selectedRows.count,selectedRows.count>1 ? "s" : "")
                
                labelCountedItems.text = stringSelected
                
            }
        }else{
            
            self.barButtonItemTrash.isEnabled = false
            self.barButtonItemTrash.tintColor = .clear
            
            var toolbarItems = toolBarCounters.items
            toolbarItems![4] = barButtonItemAdd
            toolBarCounters.setItems(toolbarItems, animated: true)
            
            labelCountedItems.text = "No item selected"
            
        }
    }
    
    //MARK: ACTION HANDLERS
    @objc func actionHandlerEdit(){
        
        if !tableViewCounters.isEditing {
            
            tableViewCounters.setEditing(true, animated: true)
            self.navigationItem.setLeftBarButtonItems([barButtonItemDone], animated: true)
            
            self.barButtonItemSelectAll.isEnabled = true
            self.barButtonItemSelectAll.tintColor = UIColor.baseColorCounters()
            
            labelCountedItems.text = "No item selected"
            
        }
        
    }
    
    @objc func actionHandlerDone(){
        
        tableViewCounters.setEditing(false, animated: true)
        
        self.barButtonItemTrash.isEnabled = false
        self.barButtonItemTrash.tintColor = .clear
        
        self.barButtonItemSelectAll.isEnabled = false
        self.barButtonItemSelectAll.tintColor = .clear
        
        var toolbarItems = toolBarCounters.items
        toolbarItems![4] = barButtonItemAdd
        toolBarCounters.setItems(toolbarItems, animated: true)
        
        self.navigationItem.setLeftBarButtonItems([barButtonItemEdit], animated: true)
        
        totalItemsAndCalculatedTimes()
        
    }
    
    @IBAction func actionHandlerSelectAll(_ sender: Any) {
        
        let totalRows = tableViewCounters.numberOfRows(inSection: 0)
        
        for row in 0..<totalRows {
            tableViewCounters.selectRow(at: NSIndexPath(row: row, section: 0) as IndexPath, animated: false, scrollPosition: UITableView.ScrollPosition.none)
        }
        
        validateShowHideTrashAndShareTotalItems()
        
    }
    
    @objc func actionHandlerAdd(){
        openCreateCounter()
    }
    
    func openCreateCounter(){
        let createCounterViewController = self.storyboard?.instantiateViewController(identifier: "createCounterID") as! AddCounterViewController
        self.navigationController?.pushViewController(createCounterViewController, animated: true)
    }
    
    @objc func actionHandlerShareInfo(){
        
        if let selectedRows = tableViewCounters.indexPathsForSelectedRows {
            
            var items:[Counter] = []
            for indexPath in selectedRows  {
                items.append(arrayLocalCounterList[indexPath.row])
            }
            
            var textArray:[String] = []
            
            for item in items {
                let string = String(format: "%i| %@", item.count, item.title)
                textArray.append(string)
            }
            
            let text = String(format: "This information is about our my counters: \n %@",textArray.joined(separator: ", "))
            
            let shareAll = [text]
            let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
            //activityViewController.popoverPresentationController?.sourceView = self.view
            
            
            if let wPPC = activityViewController.popoverPresentationController {
                wPPC.sourceView = self.view
                //  or
                wPPC.barButtonItem = barButtonItemShare
            }
            
            self.present(activityViewController, animated: true, completion: nil)
            
        }
        
    }
    
    @IBAction func actionHandlerDelete(_ sender: Any) {
        
        let alert = UIAlertController(title: "Delete Counters", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.view.tintColor = UIColor.baseColorCounters()
        
        var titleDelete:String = "Delete Counters"
        
        if let selectedRows = tableViewCounters.indexPathsForSelectedRows {
            titleDelete = String(format: "Delete %i counter%@", selectedRows.count,( selectedRows.count>1 ? "s" : ""))
            if selectedRows.count == arrayLocalCounterList.count &&  selectedRows.count > 1 {
                titleDelete = String(format: "Delete all counters")
            }
        }
        alert.addAction(UIAlertAction(title: titleDelete, style: .destructive , handler:{ (UIAlertAction)in
                            
            self.validateOnlyOneCounterDelete()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            print("Cancel")
        }))
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.barButtonItem = sender as? UIBarButtonItem
        }

        self.present(alert, animated: true, completion: {
            print("completion block")
        })
        
    }
    
    func validateOnlyOneCounterDelete(){
        
        if let selectedRows = tableViewCounters.indexPathsForSelectedRows {
            
            if selectedRows.count > 1 {
                showAlertOnlyOneCounterDelete()
            }else{
                initFlowDeleteCounter()
            }
        }
    }
    
    
    func initFlowDeleteCounter() {
        
        if Reachability.isConnectedToNetwork(){
            FlowDeleteCounterAPI()
        }else{
            tryAgainDeleteCounter()
        }
        
    }
    
    func tryAgainDeleteCounter() {
        
        let indexPathSelected = tableViewCounters.indexPathForSelectedRow
        
        let counterObject = arrayLocalCounterList[indexPathSelected!.row]
        
        let titleAlert = String(format: "Couldn't delete counter \"%@\"", counterObject.title)
        
      
        let alertController = UIAlertController(title: titleAlert, message:"The internet connection appears to be offline", preferredStyle: .alert)
        
        alertController.view.tintColor = UIColor.baseColorCounters()
        
        alertController.addAction(UIAlertAction(title: "Retry", style: .cancel, handler: {action in
            alertController.dismiss(animated: true, completion: nil)
            self.initFlowDeleteCounter()
        }))
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: {action in
            print("Dismiss only")
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertOnlyOneCounterDelete() {
        
        let alertController = UIAlertController(title: "Couldn't delete the counters", message:"Only one counter can be deleted at a time, please delete the others.", preferredStyle: .alert)
        
        alertController.view.tintColor = UIColor.baseColorCounters()
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func FlowDeleteCounterAPI(){
        
        let stringURL = String(format: "%@%@", Constants.baseURL, Api.COUNTER.rawValue)
        let indexPathSelected = tableViewCounters.indexPathForSelectedRow
        let idCounter = arrayLocalCounterList[indexPathSelected!.row].id
        

        guard let url = URL(string: stringURL) else {
                print("Error: cannot create URL")
                return
            }
            // Create the url request
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            
            let parameterDictionary = ["id" : idCounter]
            
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
                    
                    DispatchQueue.main.async {
                        self.errorDeleteCounter()
                    }
                     return
                 }

                 if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    // check for http errors
                    DispatchQueue.main.async {
                        self.errorDeleteCounter()
                    }
                    
                 }

                 do {
                     if let convertedJsonIntoArray = try JSONSerialization.jsonObject(with: data, options: []) as? NSArray {

                         if convertedJsonIntoArray.count > 0 {
                            
                            DispatchQueue.main.async {
                                self.initFlowCounters()
                            }
                            
                         }
                     }
                 }
                 catch let error as NSError {
                     print("catch let error")
                     print(error.localizedDescription)
                    DispatchQueue.main.async {
                        self.errorDeleteCounter()
                    }
                 }
                    
                
        }.resume()
    }
    
    func errorDeleteCounter(){
        self.showAlert(title: "Couldn't delete the counter", message: "There was a problem on the server, please try again later.")
    }

    func showAlert(title:String, message: String) {
        
        let alertController = UIAlertController(title: title, message:
        message, preferredStyle: .alert)
        
        alertController.view.tintColor = UIColor.baseColorCounters()
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: {action in
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func deleteSelectedCounters(){
        
        if let selectedRows = tableViewCounters.indexPathsForSelectedRows {
            
            //1
            var items:[Counter] = []
            for indexPath in selectedRows  {
                items.append(arrayLocalCounterList[indexPath.row])
            }
            
            for item in items {
                if let index = arrayLocalCounterList.firstIndex(of: item) {
                    arrayLocalCounterList.remove(at: index)
                }
            }
            
            // 3
            tableViewCounters.beginUpdates()
            tableViewCounters.deleteRows(at: selectedRows, with: .automatic)
            tableViewCounters.endUpdates()
            
        }
    }
    
    //MARK: IMPLEMENTACION DE AUMENTAR Y DISMINUIR
    var GLCounterCell: CounterCell!
    
    func initFlowIncrementDecrement(type:Int, title:String, id:String, counterCell:CounterCell){
        
        GLCounterCell = counterCell
        
        //1 = Increment and 2 = Drecement
        if Reachability.isConnectedToNetwork(){
            self.FlowPostSaveCounterAPI(type: type, title: title, id: id)
        }else{
            self.tryAgainIncDecCounter(type: type, title: title, id: id, option: "internet")
        }
        
    }
    
    func updateCounterCell(type:Int){
        
        let indexPathTapped = self.tableViewCounters.indexPath(for: GLCounterCell)!
        
        if type == 1 {
            GLCounterCell.GLCounter.count = GLCounterCell.GLCounter.count + 1
        }else {
            GLCounterCell.GLCounter.count = GLCounterCell.GLCounter.count - 1
        }
        
        if isSearchingInfo {
            
            filteredLocalCounterList[indexPathTapped.row] = GLCounterCell.GLCounter
            
            for (index, counter) in arrayLocalCounterList.enumerated() {
                if counter.id == GLCounterCell.GLCounter.id {
                    arrayLocalCounterList[index] = GLCounterCell.GLCounter
                    break
                }
            }
            
        }else {
            arrayLocalCounterList[indexPathTapped.row] = GLCounterCell.GLCounter
        }
        
        //GLCounterCell.colorDependingValue(count: GLCounterCell.GLCounter.count)
        
        self.tableViewCounters.reloadRows(at: [indexPathTapped], with: .fade)
        GLCounterCell = nil
        
        totalItemsAndCalculatedTimes()
        
    }
    
    func FlowPostSaveCounterAPI(type:Int, title:String, id:String) {

        var stringURL = String(format: "%@%@", Constants.baseURL, Api.INC_COUNTER.rawValue)
        
        if type == 2 {
            stringURL = String(format: "%@%@", Constants.baseURL, Api.DEC_COUNTER.rawValue)
        }
        

        guard let url = URL(string: stringURL) else {
                print("Error: cannot create URL")
                return
            }
            // Create the url request
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let parameterDictionary = ["id" : id]
            
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
                    
                    DispatchQueue.main.async {
                        self.tryAgainIncDecCounter(type: type, title: title, id: id, option: "")
                    }
                     return
                 }

                 if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    // check for http errors
                    DispatchQueue.main.async {
                        self.tryAgainIncDecCounter(type: type, title: title, id: id, option: "")
                    }
                    
                 }

                 do {
                     if let convertedJsonIntoArray = try JSONSerialization.jsonObject(with: data, options: []) as? NSArray {

                         if convertedJsonIntoArray.count > 0 {
                            
                            DispatchQueue.main.async {
                                self.updateCounterCell(type: type)
                            }
                            
                         }
                     }
                 }
                 catch let error as NSError {
                     print("catch let error")
                     print(error.localizedDescription)
                    DispatchQueue.main.async {
                        self.tryAgainIncDecCounter(type: type, title: title, id: id, option: "")
                    }
                 }
                    
                    
                
            }.resume()
    }
    
    func tryAgainIncDecCounter(type:Int, title:String, id:String, option:String) {
        
        let titleAlert = String(format: "Couldn't update the \"%@\" counter to %@", title, type==1 ? "1":"-1")
        
        var message = "There was a problem on the server, please try again later."
        
        if option == "internet" {
            message = "The internet connection appears to be offline."
        }
        
        let alertController = UIAlertController(title: titleAlert, message:message, preferredStyle: .alert)
        
        alertController.view.tintColor = UIColor.baseColorCounters()
        
        alertController.addAction(UIAlertAction(title: "Retry", style: .cancel, handler: {action in
            alertController.dismiss(animated: true, completion: nil)
            self.initFlowIncrementDecrement(type: type, title: title, id: id, counterCell:self.GLCounterCell)
        }))
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: {action in
            print("Dismiss only")
        }))
        
        
        self.present(alertController, animated: true, completion: nil)
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
