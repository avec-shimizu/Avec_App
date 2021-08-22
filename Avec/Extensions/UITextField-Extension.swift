//
//  UITextField-Extension.swift
//  BallRoomMP
//
//  Created by 清水正明 on 2021/03/13.
//

import UIKit

extension UITextField {
    
    //アンダーバーを追加
    func addBorderBottom(height:CGFloat,color:UIColor){
        
        let border = CALayer()
        
        border.frame = CGRect(x: 0, y: self.frame.height - height, width: self.frame.width, height: height)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
}
extension UILabel {
    //アンダーバーを追加
    func addBorderBottom(height:CGFloat,width:CGFloat,color:UIColor){
        
        let border = CALayer()
        
        border.frame = CGRect(x: 0, y: self.frame.height - height, width: width, height: height)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
}


class CustomTextField: UITextField {

    // 下線用のUIViewを作っておく
    let underline: UIView = UIView()
    let gradientLayer = CAGradientLayer()

    override func layoutSubviews() {
        super.layoutSubviews()

        self.frame.size.height = 50  // ここ変える
    
        composeUnderline() // 下線のスタイルセットおよび追加処理
        
    }
    
    
//    override var isHighlighted: Bool {
//
//        didSet {
//            if isHighlighted {
//                backgroundColor = .red
//            }else{
//                backgroundColor = .blue
//            }
//        }
//    }

    private func composeUnderline() {
        self.underline.frame = CGRect(
            x: 0,                    // x, yの位置指定は親要素,
            y: self.frame.height,    // この場合はCustomTextFieldを基準にする
            width: self.frame.width,
            height: 3)
     

        self.underline.backgroundColor = UIColor(red:0.36, green:0.61, blue:0.93, alpha:1.0)

        self.addSubview(self.underline)
        self.bringSubviewToFront(self.underline)
    }
  
}


