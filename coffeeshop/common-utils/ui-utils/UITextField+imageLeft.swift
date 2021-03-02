//
//  UITextField+imageLeft.swift
//  kokatu
//
//  Created by Cesar Miguel Chavez on 8/21/19.
//  Copyright © 2019 Heanan. All rights reserved.
//

import Foundation
import UIKit

extension UITextField{
    
    func imageLeft(imageLeft: UIImage){
        
        //LEFT ICON ---------------------------------------------------------
        
        //Size Image Left
        let leftImagetWidth: CGFloat = imageLeft.size.width
        let leftImageHeight: CGFloat = imageLeft.size.height
        
        //Size Content Left
        let sizeViewContentLeftImageWidth:CGFloat = 30.0
        let sizeViewContentLeftImageHeight:CGFloat = self.frame.size.height
        
        //Config Left Image
        let leftImageView = UIImageView(image: imageLeft)
        leftImageView.contentMode = .scaleAspectFit
        
        //Config Content View Left
        let viewContentLeft = UIView(frame: CGRect(x: 5, y: 0, width: sizeViewContentLeftImageWidth, height: sizeViewContentLeftImageHeight))
        viewContentLeft.isUserInteractionEnabled = false
        
        //Center Image Into Content View Left
        let imageLeftX = (sizeViewContentLeftImageWidth/2)-(leftImagetWidth/2)
        let imageLeftY = (sizeViewContentLeftImageHeight/2)-(leftImageHeight/2)
        
        leftImageView.frame = CGRect(x: imageLeftX, y: imageLeftY, width: leftImagetWidth, height: leftImageHeight)
        
        //Add Views Into Textfield Left
        self.leftViewMode = .always
        viewContentLeft.addSubview(leftImageView)
        self.leftViewMode = UITextField.ViewMode.always
        self.leftView = viewContentLeft
        
        //UI Textfield ---------------------------------------------------------
        self.layer.cornerRadius = 5.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor(red: 221/255.0, green: 221/255.0, blue: 221/255.0, alpha: 1.0).cgColor
        
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!,
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 119/255.0, green: 119/255.0, blue: 119/255.0, alpha: 1.0)])
        
    }
    
    func imageRight(imageRight: UIImage){
        
        //Size Image Right
        let rightImagetWidth: CGFloat = imageRight.size.width
        let rightImageHeight: CGFloat = imageRight.size.height
        
        //Size Content Right
        let sizeViewContentRightImageWidth:CGFloat = 15
        let sizeViewContentRightImageHeight:CGFloat = 15
        
        
        //Config Right Image
        let imageViewRight = UIImageView(image: imageRight)
        imageViewRight.contentMode = .scaleAspectFit
        
        //Config Content View Left
        let viewContentRight = UIView(frame: CGRect(x: 0, y: 0, width: sizeViewContentRightImageWidth, height: sizeViewContentRightImageHeight))
        viewContentRight.isUserInteractionEnabled = false
        
        //Center Image Into Content View Right
        let imageRightX = (sizeViewContentRightImageWidth/2)-(rightImagetWidth/2)-15
        let imageRightY = (sizeViewContentRightImageHeight/2)-(rightImageHeight/2)
        
        imageViewRight.frame = CGRect(x:imageRightX, y:imageRightY, width:rightImagetWidth, height:rightImageHeight)
        
        //Add Views Into Textfield Right
        self.rightViewMode = .always
        viewContentRight.addSubview(imageViewRight)
        self.rightViewMode = UITextField.ViewMode.always
        self.rightView = viewContentRight
        
    }
    
    func setPaddingWithImage(imageLeft: UIImage? = nil, imageRight:UIImage, textField: UITextField){
        
        //LEFT ICON ---------------------------------------------------------
        
        if imageLeft != nil {
            //Size Image Left
            let leftImagetWidth: CGFloat = imageLeft!.size.width
            let leftImageHeight: CGFloat = imageLeft!.size.height
            
            //Size Content Left
            let sizeViewContentLeftImageWidth:CGFloat = 30.0
            let sizeViewContentLeftImageHeight:CGFloat = textField.frame.size.height
            
            //Config Left Image
            let leftImageView = UIImageView(image: imageLeft)
            leftImageView.contentMode = .scaleAspectFit
            
            //Config Content View Left
            let viewContentLeft = UIView(frame: CGRect(x: 0, y: 0, width: sizeViewContentLeftImageWidth, height: sizeViewContentLeftImageHeight))
            viewContentLeft.isUserInteractionEnabled = false
            
            //Center Image Into Content View Left
            let imageLeftX = (sizeViewContentLeftImageWidth/2)-(leftImagetWidth/2)
            let imageLeftY = (sizeViewContentLeftImageHeight/2)-(leftImageHeight/2)
            
            leftImageView.frame = CGRect(x: imageLeftX, y: imageLeftY, width: leftImagetWidth, height: leftImageHeight)
            
            //Add Views Into Textfield Left
            textField.leftViewMode = .always
            viewContentLeft.addSubview(leftImageView)
            textField.leftViewMode = UITextField.ViewMode.always
            textField.leftView = viewContentLeft
        }
        
        //RIGHT ICON ---------------------------------------------------------
        
        //Size Image Right
        let rightImagetWidth: CGFloat = imageRight.size.width
        let rightImageHeight: CGFloat = imageRight.size.height
        
        //Size Content Right
        let sizeViewContentRightImageWidth:CGFloat = 25
        let sizeViewContentRightImageHeight:CGFloat = textField.frame.size.height
        
        
        //Config Right Image
        let imageViewRight = UIImageView(image: imageRight)
        imageViewRight.contentMode = .scaleAspectFit
        
        //Config Content View Left
        let viewContentRight = UIView(frame: CGRect(x: 0, y: 0, width: sizeViewContentRightImageWidth, height: sizeViewContentRightImageHeight))
        viewContentRight.isUserInteractionEnabled = false
        
        //Center Image Into Content View Right
        let imageRightX = (sizeViewContentRightImageWidth/2)-(rightImagetWidth/2)
        let imageRightY = (sizeViewContentRightImageHeight/2)-(rightImageHeight/2)
        
        imageViewRight.frame = CGRect(x:imageRightX, y:imageRightY, width:rightImagetWidth, height:rightImageHeight)
        
        //Add Views Into Textfield Right
        textField.rightViewMode = .always
        viewContentRight.addSubview(imageViewRight)
        textField.rightViewMode = UITextField.ViewMode.always
        textField.rightView = viewContentRight
        
        //UI Textfield ---------------------------------------------------------
        
        textField.layer.cornerRadius = 5.0
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor(red: 221/255.0, green: 221/255.0, blue: 221/255.0, alpha: 1.0).cgColor
        
        if textField.placeholder != ""{
            textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!,
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 119/255.0, green: 119/255.0, blue: 119/255.0, alpha: 1.0)])
        }
    }
}
