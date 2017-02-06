//
//  SqliteDatabaseInsert.swift
//  SqliteDatabase
//
//  Created by Domagoj Kulundžić on 06/02/17.
//  Copyright © 2017 Farmeron. All rights reserved.
//

import Foundation

public class SqliteDatabaseInsert<M: SqliteDatabaseMappable>: SqliteDatabaseUpdateOperation<M> {
    public let columns: [String]
    public let values: [Any?]
    public let replace: Bool
    
    public init(mappable: M, replace: Bool = false) {
        self.columns = M.columns
        self.values = mappable.values
        self.replace = replace
        
        super.init()
    }
    
    public init(columns: [String], values: [Any?], replace: Bool = false) {
        self.columns = columns
        self.values = values
        
        self.replace = replace
        
        super.init()
    }
    
}
