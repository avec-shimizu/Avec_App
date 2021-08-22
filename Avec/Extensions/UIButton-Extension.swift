//
//  UIButton-Extension.swift
//  BallRoomMP
//
//  Created by 清水正明 on 2021/03/04.
//

import Foundation
import UIKit

extension UIButton {
    
    func createCardInfoButton() -> UIButton {
        
        self.setImage(UIImage(named: "infomation")?.resize(size: .init(width: 35, height: 35)), for: .normal)
        self.tintColor = .white
        self.imageView?.contentMode = .scaleAspectFit
        return self
    }
}


