//
//  AlertMessage+Extension.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/17.
//

import UIKit

import RealmSwift
import Toast

enum ButtonType {
    case addButton, deleteButton
}

extension UIViewController {
    
    func showAlertMessage(buttonText: String, alertTitle: String?, collectionView: UICollectionView, buttonType: ButtonType, viewModel: CompanionViewModel) {
        
        let alert = UIAlertController(title: alertTitle, message: nil, preferredStyle: .alert)
        if buttonType == .addButton {
            alert.addTextField { textField in
                textField.attributedPlaceholder = NSAttributedString(string: "너! 내 동료가 돼라!", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
            }
        }
        
        let confirm = UIAlertAction(title: buttonText, style: buttonType == .addButton ? .default : .destructive) { _ in
            if buttonType == .addButton {
                guard let text = alert.textFields?.first?.text else { return }
                TripHistoryRepository.standard.fetchCompanionsRealmData()
                
                var checkData = Array<String>()
                var checkCurrentData = Array<String>()
                let splitStr = text.split(separator: " ").joined()

                TripHistoryRepository.standard.companionsTasks.forEach { checkData.append($0.companion.split(separator: " ").joined()) }
                viewModel.companions.value.forEach { checkCurrentData.append($0.companion.split(separator: " ").joined()) }

                if checkCurrentData.contains(splitStr) {
                    self.view.makeToast("이미 친구 목록에 포함되어 있습니다.")
                } else if checkData.contains(splitStr) {
                    var item = Companions(companion: "")
                    TripHistoryRepository.standard.companionsTasks.forEach { companion in
                        if companion.companion.split(separator: " ").joined() == splitStr {
                            item = companion
                        }
                    }
                    TripHistoryRepository.standard.updateItem(text: text, isContained: item)
                    
                } else  {
                    TripHistoryRepository.standard.updateItem(text: text)
                }
                
                viewModel.companions.value = TripHistoryRepository.standard.fetchTrips(.current)[0].companions
            } else {
                TripHistoryRepository.standard.deleteAllCompanionItem()
                viewModel.companions.value = TripHistoryRepository.standard.fetchTrips(.current)[0].companions
            }
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
    
    func showAlertMessage(completionHandler: @escaping () -> Void) {
        
        let alert = UIAlertController(title: "현재 여행을 종료하시겠습니까?", message: "종료시, 여행 정보가 여행 히스토리에 이동 및 저장됩니다.", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.attributedPlaceholder = NSAttributedString(string: "현재 여행의 제목을 입력해주세요.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
        
        let finishTrip = UIAlertAction(title: "네", style: .default) { _ in
            guard let text = alert.textFields?.first?.text else { return }
            let tripHistory = TripHistoryRepository.standard.fetchTrips(.history)
            
            if text.isEmpty {
                TripHistoryRepository.standard.updateTripName(text: "나의 여행 \(tripHistory.count + 1)")
            } else {
                TripHistoryRepository.standard.updateTripName(text: text)
            }
            completionHandler()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        [cancel, finishTrip].forEach { alert.addAction($0) }
        self.present(alert, animated: true)
        
    }
    
    func showAlertMessage(title: String) {
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        let confirm = UIAlertAction(title: "확인", style: .default)
        
        [confirm].forEach { alert.addAction($0) }
        self.present(alert, animated: true)
        
    }
    
    func showAlertMessage(title: String, completionHandler: @escaping () -> Void) {
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        let confirm = UIAlertAction(title: "확인", style: .default) { _ in
            completionHandler()
        }
        
        [confirm].forEach { alert.addAction($0) }
        self.present(alert, animated: true)
        
    }
    
    func showAlertMessageWithCancel(title: String, completionHandler: @escaping () -> Void) {
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        let confirm = UIAlertAction(title: "확인", style: .default) { _ in
            completionHandler()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        [cancel, confirm].forEach { alert.addAction($0) }
        self.present(alert, animated: true)
        
    }
    
}

