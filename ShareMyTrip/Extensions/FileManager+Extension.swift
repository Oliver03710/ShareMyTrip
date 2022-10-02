//
//  FileManager+Extension.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/28.
//

import UIKit

import Toast
import Zip

enum DocumentError: Error {
    case createDirectoryError
    case saveImageError
    case removeDirectoryError
    case fetchImagesError
    case fetchZipFileError
    case fetchDirectoryPathError
    case compressionFailedError
    case restoreFailedError
    case fetchJsonDataError
}

enum CodableError: Error {
    case jsonDecodeError
    case jsonEncodeError
}

extension UIViewController {
    
    func documentDirectoryPath() -> URL? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return documentDirectory
    }
    
    func fetchDocumentZipFile() throws -> [URL] {
        do {
            guard let path = documentDirectoryPath() else { return [] }
            
            let docs = try FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil)
            
            let zip = docs.filter { $0.pathExtension == "zip" }
            
            return zip
            
        } catch {
            throw DocumentError.fetchZipFileError
        }
    }
    
    func saveDataToDocument(data: Data) throws {
        guard let documentPath = documentDirectoryPath() else { throw DocumentError.fetchDirectoryPathError }
        
        let jsonDataPath = documentPath.appendingPathComponent("encodedData.json")

        try data.write(to: jsonDataPath)
    }
    
    func createBackupFile() throws -> URL {
        var urlPaths: [URL] = []
        
        let documentPath = documentDirectoryPath()
        
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
    
 
    
    func unzipFile(fileURL: URL, documentURL: URL) throws {
            do {
                try Zip.unzipFile(fileURL, destination: documentURL, overwrite: true, password: nil, progress: { progress in
                    print(progress)
                }, fileOutputHandler: { unzippedFile in
                    print("복구 완료")
                })
            } catch {
                throw DocumentError.restoreFailedError
            }
        }
    
    
}
