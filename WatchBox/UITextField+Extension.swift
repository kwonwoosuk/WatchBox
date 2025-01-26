//
//  UITextField+Extension.swift
//  WatchBox
//
//  Created by 권우석 on 1/27/25.
//

import UIKit 

extension UITextField {
    func setColor(_ placeholderColor: UIColor){
        attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [
                .foregroundColor: placeholderColor,
                .font: font
            ].compactMapValues{ $0 }
        )
    }
}
