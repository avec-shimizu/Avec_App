//
//  UINavigation-Extension.swift
//  BallRoomMP
//
//  Created by 清水正明 on 2021/06/04.
//

import Foundation
import UIKit

extension UINavigationController {
    //数の分だけ戻る
    func popToViewControllers(viewstoPop:Int,animatied:Bool = true){
        if viewControllers.count > viewstoPop {
            let vc = viewControllers[viewControllers.count - viewstoPop - 1]
            popToViewController(vc, animated: animatied)
        }
    }
}
