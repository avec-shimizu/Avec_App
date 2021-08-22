//
//  UIImage-Extension.swift
//  BallRoomMP
//
//  Created by 清水正明 on 2021/03/03.
//

import Foundation
import UIKit
//画像を編集する
extension UIImage {
    func resize(size _size:CGSize) -> UIImage? {
        let widthRatio = _size.width / size.width
        let heightRatio = _size.height / size.height
        let ratio = widthRatio < heightRatio ? widthRatio :heightRatio
        let resizeSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        
        UIGraphicsBeginImageContextWithOptions(resizeSize, false, 0.0)
        draw(in: CGRect(origin: .zero, size: resizeSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsPopContext()
        
        return resizedImage
    }
    public convenience init(url: String) {
        
        guard let url = URL(string: url) else { self.init(); return}
        
           do {
            let data = try Data(contentsOf: url)
               self.init(data: data)!
               return
           } catch let err {
               print("Error : \(err.localizedDescription)")
           }
           self.init()
       }
}
