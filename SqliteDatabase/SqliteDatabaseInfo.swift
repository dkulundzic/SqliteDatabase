//
//  SqliteDatabaseInfo.swift
//  SqliteDatabase
//
//  Created by Domagoj Kulundžić on 03/02/17.
//  Copyright © 2017 Farmeron. All rights reserved.
//

import Foundation

public class SqliteDatabaseInfo {
    
    public static let defaultIdentifier = "com.SqliteDatabaseInfo.Default"
    public let userIdentifier: String
    
    public init(userIdentifier: String) {
        self.userIdentifier = userIdentifier.isEmpty ? SqliteDatabaseInfo.defaultIdentifier: userIdentifier
    }
    
    public func getDatabasePath() -> String {
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let databaseURL = documentsDirectoryURL.appendingPathComponent("\(userIdentifier).db")
        
        return databaseURL.path
    }
}
