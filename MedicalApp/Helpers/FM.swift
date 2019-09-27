//  FM.swift
//  MedicalApp
//
//  Created by Alex Kholodoff on 9/16/19.
//  Copyright © 2019 iOS Team. All rights reserved.

import Foundation

struct FM {
    
    public static var documentsDirectoryURL: URL {
        return FileManager.default.urls(for:.documentDirectory, in: .userDomainMask)[0]
    }
    
    public static func fileURLInDocumentDirectory(_ fileName: String) -> URL {
        
        let url = self.documentsDirectoryURL.appendingPathComponent(fileName)
        print("fileName = ", fileName, ", url = " ,url)
        return url
    }
    
    // func get data and name file, create jpg file in folder Documenters
    public static func storeImageToDocumentDirectory(data: Data, fileName: String) -> URL? {
        
        let fileURL = self.fileURLInDocumentDirectory(fileName)
        do {
            try data.write(to: fileURL)
            print("fileURL = ", fileURL)
            return fileURL
        } catch {
            return nil
        }
    }
    
    public static func getUrlForSlide(_ id: Int) -> URL{
        let url = FM.documentsDirectoryURL.appendingPathComponent("\(id)")
        return url
    }
    
    // MARK: - create dir for storage pic and video from of the slide in Document Directory
    public static func createDir(_ id: Int) {
        
        // check if the file already exist at the destination folder if you don't want to download it twice
        if !FileManager.default.fileExists(atPath: FM.documentsDirectoryURL.appendingPathComponent("\(id)").path) {
            
            print("Dir \(id) no exist, create it dir!")
            
            let url = FM.documentsDirectoryURL.appendingPathComponent("\(id)")
            
            do {
                try FileManager.default.createDirectory(atPath: url.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("error create dir: ", id)
            }
            
        }
    }
}

// TODO: - for remove

// func get data and name file, create video file in folder Documenters
//    public static func storeVideoToDocumentDirectory(data: Data, fileName: String) -> URL? {
//        
//        let fileURL = self.fileURLInDocumentDirectory(fileName)
//        do {
//            try data.write(to: fileURL)
//            return fileURL
//        } catch {
//            return nil
//        }
//    }
