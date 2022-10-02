//
//  BackupViewController.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/28.
//

import UIKit
import MapKit

import PanModal
import SnapKit
import Toast
import Zip

final class BackupViewController: BaseViewController {

    // MARK: - Properties
    
    private lazy var tableView: BaseTableView = {
        let tv = BaseTableView(frame: .zero, style: .plain, cellClass: BackupTableViewCell.self, forCellReuseIdentifier: BackupTableViewCell.reuseIdentifier, delegate: self)
        tv.bounces = false
        return tv
    }()
    
    private lazy var backupButton: BaseButton = {
        let btn = BaseButton(buttonTitle: "백업하기", textColor: .white, backgroundColor: .systemBrown, cornerRadius: 12)
        btn.addTarget(self, action: #selector(backupButtonClicked), for: .touchUpInside)
        return btn
    }()
    
    private lazy var restoreButton: BaseButton = {
        let btn = BaseButton(buttonTitle: "복구하기", textColor: .white, backgroundColor: .systemBrown, cornerRadius: 12)
        btn.addTarget(self, action: #selector(restoreButtonClicked), for: .touchUpInside)
        return btn
    }()
    
    var zipFiles: [URL] = []
    var mapView: MKMapView?
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
    }
    
    
    // MARK: - Selectors
    
    @objc func backupButtonClicked() {
        do {
            try TripHistoryRepository.standard.saveEncodedDataToDocument(vc: self)
            let backupFilePath = try self.createBackupFile()
            
            let vc = UIActivityViewController(activityItems: [backupFilePath], applicationActivities: [])
            present(vc, animated: true)
            do {
                zipFiles = try self.fetchDocumentZipFile()
            }
            catch {
                print(#function, "실패")
            }
        } catch {
            print(error)
        }
    }
    
    @objc func restoreButtonClicked() {
        showAlertMessage(title: "복구를 시작합니다. 기존 데이터는 모두 삭제됩니다.") {
            
            let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.archive], asCopy: true)
            documentPicker.delegate = self
            documentPicker.allowsMultipleSelection = false
            self.present(documentPicker, animated: true)
            
        }
    }
    
    
    // MARK: - Helper Functions
    
    override func configureUI() {
        setConstraints()
        view.backgroundColor = .systemBackground
        
    }
    
    func setConstraints() {
        [restoreButton, backupButton, tableView].forEach { view.addSubview($0) }
        
        restoreButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.centerX.equalTo(view.snp.centerX).multipliedBy(0.7)
            make.height.equalTo(44)
            make.width.equalTo(restoreButton.snp.height).multipliedBy(2)
        }
        
        backupButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.equalTo(restoreButton.snp.trailing).offset(16)
            make.height.equalTo(restoreButton.snp.height)
            make.width.equalTo(restoreButton.snp.width)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(restoreButton.snp.bottom).offset(16)
            make.directionalHorizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    func restoreRealm(urls: [URL], index: Int) {
        
        let selectedFileURL = urls[index]
        
        guard let path = documentDirectoryPath() else {
            view.makeToast("선택하신 파일을 찾을 수 없습니다.")
            return
        }
        
        let sandboxFileURL = path.appendingPathComponent(selectedFileURL.lastPathComponent)
        
        if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
            
            let fileURL = path.appendingPathComponent(selectedFileURL.lastPathComponent)
            
            do {
                try Zip.unzipFile(fileURL, destination: path, overwrite: true, password: nil, progress: { progress in
                    print("progress: \(progress)")
                }, fileOutputHandler: { unzippedFile in
                    print("\(unzippedFile)")
                    self.view.makeToast("복구가 완료되었습니다.")
                    
                    do {
                        try TripHistoryRepository.standard.restoreRealmForBackupFile()
                    } catch {
                        print("복구에 실패하였습니다: \(error)")
                    }
                    
                    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                    let sceneDelegate = windowScene?.delegate as? SceneDelegate
                    let vc = StartingViewController()
                    sceneDelegate?.window?.rootViewController = vc
                    sceneDelegate?.window?.makeKeyAndVisible()
                })
                
            } catch {
                view.makeToast("압축 해제에 실패했습니다.")
            }
        }
    }
    
}


// MARK: - Extension: PanModalPresentable

extension BackupViewController: PanModalPresentable {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    var panScrollable: UIScrollView? {
        return nil
    }

    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(UIScreen.main.bounds.height / 100)
    }

    var anchorModalToLongForm: Bool {
        return false
    }
}


// MARK: - Extension: UITableViewDelegate

extension BackupViewController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CustomCGFloats.settingView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showAlertMessageWithCancel(title: "해당 데이터로 복구하시겠습니까?") {
            do {
                let mv = MapViewController()
                mv.delegate = self
                self.presentPanModal(mv)
                let arr = try self.fetchDocumentZipFile()
                self.restoreRealm(urls: arr, index: indexPath.row)
            } catch {
                print(error)
            }
        }
    }
    
}


// MARK: - Extension: UITableViewDataSource

extension BackupViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        do {
            let arr = try fetchDocumentZipFile()
            return arr.count
        } catch {
            print(error)
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BackupTableViewCell.reuseIdentifier, for: indexPath) as? BackupTableViewCell else { return UITableViewCell() }
        
        do {
            let arr = try fetchDocumentZipFile()
            cell.backupDataLabel.text = arr[indexPath.row].lastPathComponent
            return cell
        } catch {
            print(error)
        }
        
        return cell
    }
    
}


// MARK: - Extension: UIDocumentPickerDelegate

extension BackupViewController: UIDocumentPickerDelegate {
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        view.makeToast("파일 선택을 취소했습니다.")
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        guard let selectedFileURL = urls.first else {
            view.makeToast("선택하신 파일을 찾을 수 없습니다.")
            return
        }
        
        guard let path = documentDirectoryPath() else {
            view.makeToast("선택하신 파일을 찾을 수 없습니다.")
            return
        }
        
        let sandboxFileURL = path.appendingPathComponent(selectedFileURL.lastPathComponent)
        
        if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
            
            let fileURL = path.appendingPathComponent(selectedFileURL.lastPathComponent)
            
            do {
                try Zip.unzipFile(fileURL, destination: path, overwrite: true, password: nil, progress: { progress in
                    print("progress: \(progress)")
                }, fileOutputHandler: { unzippedFile in
                    print("\(unzippedFile)")
                    self.view.makeToast("복구가 완료되었습니다.")
                    
                    do {
                        try TripHistoryRepository.standard.restoreRealmForBackupFile()
                    } catch {
                        print("복구에 실패하였습니다: \(error)")
                    }
                    
                    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                    let sceneDelegate = windowScene?.delegate as? SceneDelegate
                    let vc = StartingViewController()
                    
                    sceneDelegate?.window?.rootViewController = vc
                    sceneDelegate?.window?.makeKeyAndVisible()
                })
                
            } catch {
                view.makeToast("압축 해제에 실패했습니다.")
            }
            
        } else {
            
            do {
                
                try FileManager.default.copyItem(at: selectedFileURL, to: sandboxFileURL)
                
                let fileURL = path.appendingPathComponent(selectedFileURL.lastPathComponent)
                
                try Zip.unzipFile(fileURL, destination: path, overwrite: true, password: nil, progress: { progress in
                    print("progress: \(progress)")
                }, fileOutputHandler: { unzippedFile in
                    print("\(unzippedFile)")
                    self.view.makeToast("복구가 완료되었습니다.")
                    
                    do {
                        try TripHistoryRepository.standard.restoreRealmForBackupFile()
                    } catch {
                        print("복구에 실패하였습니다: \(error)")
                    }
                    
                    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                    let sceneDelegate = windowScene?.delegate as? SceneDelegate
                    let vc = StartingViewController()

                    sceneDelegate?.window?.rootViewController = vc
                    sceneDelegate?.window?.makeKeyAndVisible()
                })
                
            } catch {
                view.makeToast("압축 해제에 실패했습니다.")
                
            }
        }
    }
    
}


// MARK: - Extension: TransferMapViewDelegate

extension BackupViewController: TransferMapViewDelegate {
    
    func passMapView(_ mapView: MKMapView) {
        LocationHelper.standard.removeAnnotations(mapView, status: .current)
        LocationHelper.standard.routes.removeAll()
        mapView.removeOverlays(mapView.overlays)
    }
}
