//
//  Extension.swift
//  KaraNew
//
//  Created by Akshay Purohit on 5/17/21.
//

import Foundation
import UIKit

//MARK:UIViewContoroller
extension UIViewController {
    func showToast(message : String,font: UIFont){
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "閉じる", style: .cancel, handler: { action in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func hideKeyboardWhenTappedAround() {
            let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
        }
        
        @objc func dismissKeyboard() {
            view.endEditing(true)
        }
}
//MARK:UIView
extension UIView {
    
     func anchor(top:NSLayoutYAxisAnchor? = nil,bottom:NSLayoutYAxisAnchor? = nil,
                left:NSLayoutXAxisAnchor? = nil,right:NSLayoutXAxisAnchor? = nil,
                centerY:NSLayoutYAxisAnchor? = nil,centerX:NSLayoutXAxisAnchor? = nil,
                width:CGFloat? = nil,height:CGFloat? = nil,
                topPadding:CGFloat = 0,bottomPadding:CGFloat = 0,
                leftPadding:CGFloat = 0,rightPadding:CGFloat = 0){
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top,constant: topPadding).isActive = true
        }
        if let bottom = bottom  {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -bottomPadding).isActive = true
        }
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: leftPadding).isActive = true
        }
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: -rightPadding).isActive = true
        }
        if let centerY = centerY {
            self.centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
        if let centerX = centerX {
            self.centerXAnchor.constraint(equalTo: centerX).isActive = true
        }
        if let width = width {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
     }
    func addShadow(){
        
        self.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.6
        self.layer.shadowRadius = 4
    }
}
//MARK:UIColor
extension UIColor {
    static func rgb(red:CGFloat,green:CGFloat,blue:CGFloat,alpha:CGFloat) -> UIColor {
        return .init(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
}

