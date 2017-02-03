//
//  SqliteDatabaseMappable.swift
//  SqliteDatabase
//
//  Created by Domagoj Kulundžić on 03/02/17.
//  Copyright © 2017 Farmeron. All rights reserved.
//

import Foundation

public typealias SqliteDatabaseRow = [String: Any]

public protocol SqliteDatabaseMappable {
    static var tableName: String { get }
    static var columns: [String] { get }
    
    init?(row: SqliteDatabaseRow)
    var values: [AnyObject?] { get }
}

extension SqliteDatabaseMappable {
    static var tableName: String {
        return String(describing: self)
    }
    
    static var columns: [String] {
        return []
    }
    
    init?(row: SqliteDatabaseRow) {
        return nil
    }
    
    var values: [AnyObject?] {
        return []
    }
}
