//
//  CALayer+ApplySketchShadow.swift
//  Zynch
//
//  Created by Cesar Miguel Chavez on 8/22/19.
//  Copyright © 2019 Spacebar. All rights reserved.
//

import Foundation
import UIKit

extension CALayer {
    
    func ApplySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.4,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4,
        spread: CGFloat = 0,
        isCornerRadius: Bool = true)
    {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
        
        if isCornerRadius {
            cornerRadius = 5.0
        }
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.mask = mask
    }
    
    func planShadow(){
        self.shadowRadius = 4
        self.shadowOpacity = 0.5
        self.shadowColor = UIColor.black.cgColor
        self.shadowOffset = CGSize(width: 0 , height:2)
        self.cornerRadius = 12
    }
    
    func cellZynchShadow(){
        
        self.cornerRadius = 8
        self.masksToBounds = true
        
        self.masksToBounds = false
        self.shadowOffset = CGSize(width: 0, height: 0)
        self.shadowColor = UIColor.gray.cgColor
        self.shadowOpacity = 0.23
        self.shadowRadius = 4
        
        self.borderWidth = 0.5
        self.borderColor = UIColor.lightGray.cgColor
        
        
    }
    
    func viewTrianguloLeft(currentView: UIView){
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 10, y: 0))
        path.addLine(to: CGPoint(x: 0, y: currentView.frame.size.height / 2))
        path.close()

        let shape = CAShapeLayer()
        shape.fillColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1).cgColor
        shape.path = path.cgPath
        self.addSublayer(shape)
        
        let path2 = UIBezierPath()
        path2.move(to: CGPoint(x: 0, y: currentView.frame.size.height / 2))
        path2.addLine(to: CGPoint(x: 10, y: currentView.frame.size.height))
        path2.addLine(to: CGPoint(x: 0, y: currentView.frame.size.height))
        path2.close()

        let shape2 = CAShapeLayer()
        shape2.fillColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1).cgColor
        shape2.path = path2.cgPath
        self.addSublayer(shape2)
        
    }
    
    func viewTrianguloRight(currentView: UIView){
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: currentView.frame.size.width, y: 0))
        path.addLine(to: CGPoint(x: currentView.frame.size.width - 10, y: 0))
        path.addLine(to: CGPoint(x: currentView.frame.size.width, y: currentView.frame.size.height / 2))
        path.close()

        let shape = CAShapeLayer()
        shape.fillColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        shape.path = path.cgPath
        currentView.layer.addSublayer(shape)
        
        let path2 = UIBezierPath()
        path2.move(to: CGPoint(x: currentView.frame.size.width, y: currentView.frame.size.height / 2))
        path2.addLine(to: CGPoint(x: currentView.frame.size.width - 10, y: currentView.frame.size.height))
        path2.addLine(to: CGPoint(x: currentView.frame.size.width, y: currentView.frame.size.height))
        path2.close()

        let shape2 = CAShapeLayer()
        shape2.fillColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        shape2.path = path2.cgPath
        currentView.layer.addSublayer(shape2)
        
    }
    
}
