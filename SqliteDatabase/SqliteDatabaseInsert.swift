//
//  SqliteDatabaseInsert.swift
//  SqliteDatabase
//
//  Created by Domagoj Kulundzic on 16/03/2017.
//  Copyright © 2017 InBetweeners. All rights reserved.
//

import Foundation

public class SqliteDatabaseInsert<M: SqliteDatabaseMappable> {
    public let tableName: String
    public let columns: [String]
    public let values: [AnyObject?]
    public let shouldReplace: Bool
    
    public init(mappable: M, shouldReplace: Bool = false) {
        self.tableName = M.tableName
        self.columns = M.columns
        self.values = mappable.values()
        self.shouldReplace = shouldReplace
    }
}
