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
    func values() -> [Any?]
}

extension SqliteDatabaseMappable {
    public static var tableName: String {
        return String(describing: self)
    }
    
    public static var columns: [String] {
        return []
    }
    
    init?(row: SqliteDatabaseRow) {
        return nil
    }
    
    public func values() -> [Any?] {
        return []
    }
}
