//
//  SqliteDatabaseServiceTests.swift
//  SqliteDatabase
//
//  Created by Domagoj Kulundžić on 03/02/17.
//  Copyright © 2017 Farmeron. All rights reserved.
//

import XCTest
import SqliteDatabase

class SqliteDatabaseServiceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_Generic() {
        let databaseInfo = SqliteDatabaseInfo()
        SqliteDatabaseInitialisation(databaseInfo: databaseInfo, databaseDefinition: DefaultDefinition())
            .initialise { (error) in
                if let error = error, error != .alreadyExists {
                    return
                }
                
                let todo = Todo(id: "98XDS-DA1D3-DSAQ9", description: "Read a good book")
                let insert = SqliteDatabaseInsert(mappable: todo)
                SqliteDatabaseService(databaseInfo: databaseInfo)
                .executeUpdate(update: insert, completion: { (success) in
                    success ? print("Successfully inserted \(todo)"): print("Failed inserting \(todo)")
                })
        }
    }
}
