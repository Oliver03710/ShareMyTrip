//
//  FileManagerHelper.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/10/04.
//

import UIKit

import Zip

private protocol FileManagerHelperType: AnyObject {
}

final class FileManagerHelper: FileManagerHelperType {
    
    private init() { }
    
    static let standard = FileManagerHelper()
    
    // MARK: - Properties
    
    var zipFiles: [URL] = []
    
    // MARK: - Helper Functions
    
    func backupButtonClicked(vc: UIViewController) {
        do {
            try TripHistoryRepository.standard.saveEncodedDataToDocument(vc: vc)
            let backupFilePath = try self.createBackupFile(vc: vc)
            
            let ActivityVC = UIActivityViewController(activityItems: [backupFilePath], applicationActivities: [])
            vc.present(ActivityVC, animated: true)
            do {
                zipFiles = try vc.fetchDocumentZipFile()
            } catch {
                print("실패: \(error)")
            }
        } catch {
            print(error)
        }
    }
    
    func createBackupFile(vc: UIViewController) throws -> URL {
        var urlPaths: [URL] = []
        
        let documentPath = vc.documentDirectoryPath()
        
        let encodedFilePath = documentPath?.appendingPathComponent("encodedData.json")
        
        guard let realmFilePath = encodedFilePath else {
            throw DocumentError.fetchDirectoryPathError
        }
        
        guard FileManager.default.fileExists(atPath: realmFilePath.path) else {
            throw DocumentError.compressionFailedError
        }
        
        urlPaths.append(contentsOf: [realmFilePath])
        
        do {
            let zipFilePath = try Zip.quickZipFiles(urlPaths, fileName: "Trip_\(Date().toString(withFormat: "yyMMdd_HH.mm"))")
            
            return zipFilePath
        }
        catch {
            throw DocumentError.compressionFailedError
        }
    }

}
