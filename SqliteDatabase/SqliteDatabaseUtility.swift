//
//  SqliteDatabaseUtility.swift
//  SqliteDatabase
//
//  Created by Domagoj Kulundžić on 29/03/2017.
//  Copyright © 2017 Farmeron. All rights reserved.
//

import Foundation

public class SqliteDatabaseUtility {
    /**
     Checks whether a database exists at the specified path. The path should be fully specified.
     
     - parameter path: The database file path.
     - returns: True if the file exists, false if it does not.
     */
    public static func databaseExists(atPath path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }
    
    /**
     Attempts to remove the database at the specified path.
     
     - note: This method will print out a error if the file deletion throws.
     
     - parameter path: The database file path.
     - returns: True if the file was successfully removed, false if it was not.
     */
    public static func remove(atPath path: String) -> Bool {
        do {
            try FileManager.default.removeItem(atPath: path)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
}
