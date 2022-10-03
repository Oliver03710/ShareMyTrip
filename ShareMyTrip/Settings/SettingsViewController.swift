//
//  SettingsViewController.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/13.
//

import UIKit
import MapKit
import MessageUI

import AcknowList
import PanModal
import SnapKit
import Toast

final class SettingsViewController: BaseViewController {
    
    // MARK: - Properties
    
    private lazy var tableView: BaseTableView = {
        let tv = BaseTableView(frame: .zero, style: .insetGrouped, cellClass: SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.reuseIdentifier, delegate: self)
        tv.backgroundColor = .white
        tv.bounces = false
        return tv
    }()
    
    var transitionVC: (() -> Void)?
    let viewModel = SettingViewModel()
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - Helper Functions
    
    override func setConstraints() {
        [tableView].forEach { view.addSubview($0) }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.bottom.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}


// MARK: - Extension: UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsHeaderTexts.allCases.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CustomCGFloats.settingView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.setCellActions(indexPath: indexPath, vc: self)
        if indexPath == [1, 0] {
            sendMail()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = SettingsHeaderTexts.allCases[section].rawValue
        label.font = .systemFont(ofSize: 13)
        label.textColor = .gray
        return label
    }
    
}


// MARK: - Extension: UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return SettingsDataTexts.allCases.count
        case 1: return SettingsToDevTexts.allCases.count
        case 2: return SettingsInfoTexts.allCases.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.reuseIdentifier, for: indexPath) as? SettingsTableViewCell else { return UITableViewCell() }

        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        cell.setCellComponents(indexPath: indexPath)
        
        return cell
    }
    
}

// MARK: - Extension: MFMailComposeViewControllerDelegate

extension SettingsViewController : MFMailComposeViewControllerDelegate {

    private func sendMail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.setToRecipients(["jhee2619@icloud.com"])
            mail.setSubject("여행하자곰 문의사항 - ")
            mail.mailComposeDelegate = self
            self.present(mail, animated: true)
        } else {
            view.makeToast("메일 등록을 해주시거나 jhee2619@icloud.com으로 문의주세요.")
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            view.makeToast("메일 전송을 취소했습니다.")
        case .failed:
            view.makeToast("메일 전송이 실패했습니다.")
        case .saved:
            view.makeToast("메일을 임시 저장했습니다.")
        case .sent:
            view.makeToast("메일이 전송되었습니다.")
        @unknown default:
            fatalError()
        }
        controller.dismiss(animated: true)
    }
}
