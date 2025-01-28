//
//  UIViewController+Extension.swift
//  WatchBox
//
//  Created by 권우석 on 1/27/25.
//


import UIKit


extension UIViewController {
    func showAlert(title: String, message: String, button: String, completionHadler: @escaping () -> () ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert) 
        
        let button = UIAlertAction(title: button, style: .default) { action in
        }
        
        
        let cancel = UIAlertAction(title: "취소", style: .destructive)
        
        alert.addAction(cancel)
        alert.addAction(button)
        
        self.present(alert, animated: true)
    }
}



