//
//  SqliteDatabaseInfo.swift
//  SqliteDatabase
//
//  Created by Domagoj Kulundžić on 03/02/17.
//  Copyright © 2017 InBetweeners. All rights reserved.
//

import Foundation

/**
 Encapsulates data about a databases's file properties (location, name, etc.)
 */
public class SqliteDatabaseInfo {
    
    /// The default identifier to be used if a user identifier was not specified.
    public static let defaultIdentifier = "com.sqlite-database-info.default"
    
    /// User determined identifier, will be used as part of the database's name on the file system.
    public let userIdentifier: String
    
    public init(userIdentifier: String) {
        self.userIdentifier = userIdentifier.isEmpty ? SqliteDatabaseInfo.defaultIdentifier: userIdentifier
    }
    
    /**
     Creates a file path using the Documents directory and the specified identifier (default or user, 
     depending whether the user identifier was set).
     
     - Example: /Users/X/Library/Developer/CoreSimulator/Devices/B786C210-50D4-44D3-959C-681CE5718568/data/Documents/com.sqlite-database-info.default.db
     
     - returns: The database file path.
     */
    public func getDatabasePath() -> String {
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let databaseURL = documentsDirectoryURL.appendingPathComponent("\(userIdentifier).db")
        
        return databaseURL.path
    }
}
