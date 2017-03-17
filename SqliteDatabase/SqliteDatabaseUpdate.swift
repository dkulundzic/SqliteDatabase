//
//  SqliteDatabaseUpdate.swift
//  SqliteDatabase
//
//  Created by Domagoj Kulundzic on 17/03/2017.
//  Copyright © 2017 Farmeron. All rights reserved.
//

import Foundation

public class SqliteDatabaseUpdate<M: SqliteDatabaseMappable> {
    public let tableName: String
    public let columns: [String]
    public let values: [AnyObject?]
    public let whereClause: String
    
    public init(mappable: M, whereClause: String) {
        self.tableName = M.tableName
        self.columns = M.columns
        self.values = mappable.values()
        self.whereClause = whereClause
    }
}
