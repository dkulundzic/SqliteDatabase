//
//  SqliteDatabaseDelete.swift
//  SqliteDatabase
//
//  Created by Domagoj Kulundžić on 06/02/17.
//  Copyright © 2017 Farmeron. All rights reserved.
//

import Foundation

public class SqliteDatabaseDelete<M: SqliteDatabaseMappable>: SqliteDatabaseUpdate<M>  {
    public let whereClause: String
    
    public init(whereClause: String) {
        self.whereClause = whereClause
        
        super.init()
    }
}
