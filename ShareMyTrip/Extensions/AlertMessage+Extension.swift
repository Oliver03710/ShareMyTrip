//
//  AlertMessage+Extension.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/17.
//

import UIKit

extension UIViewController {
    
    func showAlertMessage(buttonText: String, alertTitle: String?, target: Observable<[String]>) {
        
        let alert = UIAlertController(title: alertTitle, message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.attributedPlaceholder = NSAttributedString(string: "너! 내 동료가 돼라!", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
        let confirm = UIAlertAction(title: buttonText, style: .default) { _ in
            target.value.append(alert.textFields?.first?.text ?? "")
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        [cancel, confirm].forEach { alert.addAction($0) }
        self.present(alert, animated: true)
        
    }
    
    func showAlertMessage(buttonText: String, alertTitle: String?, completionHandler: @escaping () -> Void) {
        
        let alert = UIAlertController(title: alertTitle, message: nil, preferredStyle: .alert)
        
        let delete = UIAlertAction(title: buttonText, style: .destructive) { _ in
            completionHandler()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        [cancel, delete].forEach { alert.addAction($0) }
        self.present(alert, animated: true)
        
    }

    
}

