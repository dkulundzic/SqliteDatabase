//
//  SqliteDatabaseInsert.swift
//  SqliteDatabase
//
//  Created by Domagoj Kulundzic on 16/03/2017.
//  Copyright © 2017 InBetweeners. All rights reserved.
//

import Foundation

/**
 Represents a single SQL Insert operation. 
 
 The Insert is initialised with a SqliteDatabaseMappable conforming instance and a flag
 that determines whether the operation should be INSERT or INSERT OR REPLACE.
 
 Both columns and values used for the Insert are taken from the generic type and SqliteDatabaseMappable instance.
 */
public class SqliteDatabaseInsert<M: SqliteDatabaseMappable> {
    public let tableName: String
    public let columns: [String]
    public let values: [Any?]
    public let shouldReplace: Bool
    
    public init(mappable: M, shouldReplace: Bool = false) {
        self.tableName = M.tableName
        self.columns = M.columns
        self.values = mappable.values()
        self.shouldReplace = shouldReplace
    }
}
