//
//  AlertMessage+Extension.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/17.
//

import UIKit

extension UIViewController {
    
    func showAlertMessage(buttonText: String, alertTitle: String?, tableView: UITableView, buttonType: ButtonType, viewModel: CompanionViewModel) {
        
        let alert = UIAlertController(title: alertTitle, message: nil, preferredStyle: .alert)
        if buttonType == .addButton {
            alert.addTextField { textField in
                textField.attributedPlaceholder = NSAttributedString(string: "너! 내 동료가 돼라!", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
            }
        }
        let confirm = UIAlertAction(title: buttonText, style: buttonType == .addButton ? .default : .destructive) { _ in
            if buttonType == .addButton {
                CompanionsRepository.standard.addItem(companion: alert.textFields?.first?.text ?? "")
            } else {
                CompanionsRepository.standard.tasks.forEach { CompanionsRepository.standard.deleteSpecificItem(item: $0) }
            }
            viewModel.checkEmpty(tableView: tableView)
            tableView.reloadData()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        [cancel, confirm].forEach { alert.addAction($0) }
        self.present(alert, animated: true)
        
    }
    
    func showAlertMessage(deleteLast: @escaping () -> Void, deleteAllItem: @escaping () -> Void, deleteAllWithTransition: @escaping () -> Void) {
        
        let alert = UIAlertController(title: "삭제할 내용을 선택해주세요.", message: nil, preferredStyle: .actionSheet)
        
        let deleteLast = UIAlertAction(title: "마지막 목적지 삭제", style: .destructive) { _ in
            deleteLast()
        }
        
        let deleteAllItem = UIAlertAction(title: "목적지 전체 삭제", style: .destructive) { _ in
            deleteAllItem()
        }
        
        let deleteAllWithTransition = UIAlertAction(title: "여행 삭제 후 초기화면으로 이동", style: .destructive) { _ in
            deleteAllWithTransition()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        [cancel, deleteLast, deleteAllItem, deleteAllWithTransition].forEach { alert.addAction($0) }
        self.present(alert, animated: true)
        
    }

    
}

