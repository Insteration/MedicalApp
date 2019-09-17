//
//  FM.swift
//  MedicalApp
//
//  Created by Alex Kholodoff on 9/16/19.
//  Copyright © 2019 iOS Team. All rights reserved.
//

import Foundation

struct FM {
    
    public static var documentsDirectoryURL: URL {
        return FileManager.default.urls(for:.documentDirectory, in: .userDomainMask)[0]
    }
    
    public static func fileURLInDocumentDirectory(_ fileName: String) -> URL {
        return self.documentsDirectoryURL.appendingPathComponent(fileName)
    }
    
    // func get data and name file, create jpg file in folder Documenters
    public static func storeImageToDocumentDirectory(data: Data, fileName: String) -> URL? {
        
        let fileURL = self.fileURLInDocumentDirectory(fileName)
        do {
            try data.write(to: fileURL)
            return fileURL
        } catch {
            return nil
        }
    }

}

// <img src="file:///1.jpg" alt="упражнения для спины"  itemprop="image"/></li>
