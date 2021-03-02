//
//  CounterCell.swift
//  coffeeshop
//
//  Created by Cesar Miguel Chavez on 01/03/21.
//

import Foundation
import UIKit

class CounterCell: UITableViewCell {
    
    @IBOutlet weak var containerCell: UIView!
    @IBOutlet weak var labelCounter: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var stepperValue: UIStepper!
    
    var counterListViewController:CounterListViewController!
    
    var GLCounter:Counter!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        print("Init CounterCell")
    }
    
    public func configure(counter: Counter, viewController:CounterListViewController){
        
        containerCell.layer.cornerRadius = 8.0
        
        counterListViewController = viewController
        GLCounter = counter
        
        labelTitle.text = counter.title
        let count = counter.count
        stepperValue.value = Double(count!)
        self.colorDependingValue(count: count)
        
    }
    
    
    @IBAction func changeStepperCounter(_ sender: Any) {
        
        let whoAmount = sender as! UIStepper
        let count = Int(whoAmount.value)
        var type = 0
        
        if count > GLCounter.count {
            //print("Incrementando");
            type = 1
        }else{
            //print("Decrementando");
            type = 2
        }
        
        counterListViewController.initFlowIncrementDecrement(type: type, title: GLCounter.title, id: GLCounter.id, counterCell: self)
    }
    
    func colorDependingValue(count: Int!){
        if count > 0 {
            labelCounter.textColor = UIColor.baseColorCounters()
        }else{
            labelCounter.textColor = UIColor.zeroColorCounter()
        }
        labelCounter.text = String(format: "%i",count)
    }
    
}
