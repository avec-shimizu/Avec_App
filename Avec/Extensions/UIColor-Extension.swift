//
//  UIColor-Extension.swift
//  BallRoomMP
//
//  Created by 清水正明 on 2021/03/04.
//

import Foundation
import UIKit

extension UIColor {
    
    //RGB
    static func rgb(red:CGFloat,green:CGFloat,blue:CGFloat) -> UIColor {
        return .init(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    static func rgbAlpha(red:CGFloat,green:CGFloat,blue:CGFloat,alpha:CGFloat) -> UIColor {
        return .init(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
    //グラデーション
    static func colorWithGradient(size: CGSize, colors: [UIColor]) -> UIColor {

           let backgroundGradientLayer = CAGradientLayer()
           backgroundGradientLayer.frame = CGRect(origin: .zero, size: size)
           backgroundGradientLayer.colors = colors.map { $0.cgColor }
           UIGraphicsBeginImageContext(size)
           backgroundGradientLayer.render(in: UIGraphicsGetCurrentContext()!)
           let backgroundColorImage = UIGraphicsGetImageFromCurrentImageContext()
           UIGraphicsEndImageContext()
           return UIColor(patternImage: backgroundColorImage!)
       }
}
