//
//  SqliteDatabaseUpdate.swift
//  SqliteDatabase
//
//  Created by Domagoj Kulundžić on 06/02/17.
//  Copyright © 2017 Farmeron. All rights reserved.
//

import Foundation

public class SqliteDatabaseUpdate<M: SqliteDatabaseMappable>: SqliteDatabaseUpdateOperation<M> {
    public let columns: [String]
    public let values: [Any?]
    public let whereClause: String
    
    public init(mappable: M, whereClause: String) {
        self.columns = M.columns
        self.values = mappable.values
        self.whereClause = whereClause
        
        super.init()
    }
    
    public init(columns: [String], values: [Any?], whereClause: String) {
        self.columns = columns
        self.values = values
        self.whereClause = whereClause
        
        super.init()
    }
    
}
