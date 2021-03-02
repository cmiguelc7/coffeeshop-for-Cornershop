//
//  CustomDrinksCell.swift
//  coffeeshop
//
//  Created by Cesar Miguel Chavez on 02/03/21.
//

import Foundation
import UIKit

class CustomLabelCell : UICollectionViewCell {
    
    @IBOutlet weak var labelTitleExample: UILabel!
    
    @IBOutlet private var maxWidthConstraint: NSLayoutConstraint! {
        didSet {
                 maxWidthConstraint.isActive = false
             }
    }
    
    var maxWidth: CGFloat? = nil {
         didSet {
             guard let maxWidth = maxWidth else {
                 return
             }
             maxWidthConstraint.isActive = true
             maxWidthConstraint.constant = maxWidth
         }
     }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint.activate([
                    contentView.leftAnchor.constraint(equalTo: leftAnchor),
                    contentView.rightAnchor.constraint(equalTo: rightAnchor),
                    contentView.topAnchor.constraint(equalTo: topAnchor),
                    contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
                ])
        
    }

}
