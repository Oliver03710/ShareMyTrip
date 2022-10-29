//
//  SettingViewModel.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/10/04.
//

import UIKit
import MessageUI

import AcknowList
import PanModal
import Toast

final class SettingViewModel {
    
    // MARK: - Properties
    
    var version: Observable<String> = Observable("")
    
    
    // MARK: - Helper Functions
    
    func versionData() -> String? {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String,
              let _ = dictionary["CFBundleVersion"] as? String else { return nil }
        
        let versionAndBuild: String = "\(version)"
        return versionAndBuild
    }
    
    private func moveToReview() {
        if let reviewURL = URL(string: "itms-apps://itunes.apple.com/app/itunes-u/id\(6443563655)?ls=1&mt=8&action=write-review"), UIApplication.shared.canOpenURL(reviewURL) {
            UIApplication.shared.open(reviewURL, options: [:], completionHandler: nil)
        }
    }
    
    func setCellActions(indexPath: IndexPath, vc: UIViewController) {
        switch indexPath {
        case [0, 0]:
            FileManagerHelper.standard.backupButtonClicked(vc: vc)
        case [0, 1]:
            let backupVC = BackupViewController()
            vc.presentPanModal(backupVC)
        case [1, 1]:
            moveToReview()
        case [2, 0]:
            guard let url = Bundle.main.url(forResource: "Package", withExtension: "resolved"),
                  let data = try? Data(contentsOf: url),
                  let acknowList = try? AcknowPackageDecoder().decode(from: data) else { return }

            let AcknowVC = AcknowListViewController()
            AcknowVC.acknowledgements = acknowList.acknowledgements
            vc.navigationController?.pushViewController(AcknowVC, animated: true)
        default:
            break
        }
    }
}
