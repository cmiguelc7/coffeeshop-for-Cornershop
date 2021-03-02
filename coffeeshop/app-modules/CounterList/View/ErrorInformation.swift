//
//  ErrorInformation.swift
//  coffeeshop
//
//  Created by Cesar Miguel Chavez on 01/03/21.
//

import Foundation
import UIKit

protocol ErrorInformationDelegate {
    func touchErrorInformationAction()
}

class ErrorInformation : UIViewController {
    
    var delegate: ErrorInformationDelegate?
    
    @IBOutlet weak var imageViewIcon: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var btnAction: UIButton!
    
    var stringIcon:String!
    var stringTitle:String!
    var stringeDescription:String!
    var stringButton:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    func configUI(){
        btnAction.layer.cornerRadius = 5.0
        setStrings()
    }
    
    func setStrings(){
        labelTitle.text = stringTitle
        labelDescription.text = stringeDescription
        btnAction.setTitle(stringButton, for: .normal)
        imageViewIcon.image = UIImage(named: stringIcon)
    }
    
    @IBAction func actionHandler(_ sender: Any) {
        self.delegate?.touchErrorInformationAction()
        print("Go to delegate")
    }
}
