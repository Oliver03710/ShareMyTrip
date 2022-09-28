//
//  SwipeAction+Extension.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/22.
//

import UIKit

enum ViewConCase {
    case companion, history
}

extension UISwipeActionsConfiguration {
    
    func trailingDeleteAction(indexPath: IndexPath, viewControllerCase: ViewConCase, tableView: UITableView) -> UISwipeActionsConfiguration {
        
        var currentTrip = TripHistoryRepository.standard.fetchCurrentTrip()
        
        let delete = UIContextualAction(style: .destructive, title: nil) { action, view, completionHandler in
            
            switch viewControllerCase {
                
            case .companion:
                let task = currentTrip[0].companions[indexPath.row]
                TripHistoryRepository.standard.deleteCompanionItem(item: task)
                currentTrip = TripHistoryRepository.standard.fetchCurrentTrip()
                tableView.reloadData()
                tableView.isHidden = currentTrip[0].companions.isEmpty ? true : false
                
            case .history:
                let task = TripHistoryRepository.standard.tasks[indexPath.row]
                TripHistoryRepository.standard.deleteItem(item: task)
                TripHistoryRepository.standard.fetchRealmData()
                tableView.reloadData()
                tableView.isHidden = TripHistoryRepository.standard.tasks.isEmpty ? true : false
            }
        }
        
        delete.image = UIImage(systemName: "trash.fill")
        delete.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
}
