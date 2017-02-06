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
    
    private let databaseInfo = SqliteDatabaseInfo()
    private var service: SqliteDatabaseService!
    
    override func setUp() {
        super.setUp()
        
        SqliteDatabaseInitialisation(databaseInfo: databaseInfo, databaseDefinition: DefaultDefinition())
            .initialise { (error) in
                if let error = error, error != .alreadyExists {
                    return
                }
        }
        
        service = SqliteDatabaseService(databaseInfo: databaseInfo)
    }
    
    override func tearDown() {
        super.tearDown()
        
//        do {
//            try FileManager.default.removeItem(at:
//                URL(fileURLWithPath: databaseInfo.getDatabasePath())
//            )
//        } catch {
//            print("Failed removing the database.")
//        }
    }
    
    func test_Insertion() {
        let todo = Todo(description: "Take the girl out", completed: true)
        let insert = SqliteDatabaseInsert(mappable: todo)
        
        var success = false
        
        service.executeUpdateOperation(update: insert, completion: { (result) in
            success = result
        })
        
        if success {
            self.service.executeQuery(query: SqliteDatabaseQuery<Todo>(whereClause: "Description == '\(todo.description)'")) { (rows) in
                XCTAssert(rows.count == 1, "As the service returned \"true\", the specified row should be present in the database, but was not found.")
            }
        } else {
            self.service.executeQuery(query: SqliteDatabaseQuery<Todo>(whereClause: "Description == '\(todo.description)'")) { (rows) in
                XCTAssert(rows.count == 0, "As the service returned \"false\", the specified row should not be present in the database, but was found.")
            }
        }
    }
//
//    func test_UpdateImplicit() {
//        let todo = Todo(id: "25F98F0A-AAB9-4A16-AF60-283C005B3FD9", description: "Read a really good book")
//        let update = SqliteDatabaseUpdate(mappable: todo, whereClause: "Id == '\(todo.id)'")
//        
//        var success = false
//        
//        service.executeUpdateOperation(update: update, completion: { (result) in
//            success = result
//        })
//        
//        if success {
//            self.service.executeQuery(query: SqliteDatabaseQuery<Todo>(whereClause: "Description == 'Read a really good book'")) { (rows) in
//                XCTAssert(rows.count == 1, "As the service returned \"true\", the specified row should be present in the database, but was not found.")
//            }
//        } else {
//            self.service.executeQuery(query: SqliteDatabaseQuery<Todo>(whereClause: "Description == 'Read a really good book'")) { (rows) in
//                XCTAssert(rows.count == 0, "As the service returned \"false\", the specified row should not be present in the database, but was found.")
//            }
//        }
//    }
//    
//    func test_UpdateExplicit() {
//        let update = SqliteDatabaseUpdate<Todo>(columns: ["IsCompleted"], values: [0], whereClause: "Id == '79D42CD3-0875-492F-BAF7-D922524A8A30'")
//        
//        var success = false
//        
//        service.executeUpdateOperation(update: update, completion: { (result) in
//            success = result
//        })
//        
//        if success {
//            self.service.executeQuery(query: SqliteDatabaseQuery<Todo>(whereClause: "Id == '79D42CD3-0875-492F-BAF7-D922524A8A30' AND IsCompleted == 0")) { (rows) in
//                XCTAssert(rows.count == 1, "As the service returned \"true\", the specified row should be present in the database, but was not found.")
//            }
//        } else {
//            self.service.executeQuery(query: SqliteDatabaseQuery<Todo>(whereClause: "Id == '79D42CD3-0875-492F-BAF7-D922524A8A30' AND IsCompleted == 0")) { (rows) in
//                XCTAssert(rows.count == 0, "As the service returned \"false\", the specified row should not be present in the database, but was found.")
//            }
//        }
//    }
//    
//    func test_Deletion() {
//        let delete = SqliteDatabaseDelete<Todo>(whereClause: "1 = 1")
//        
//        service.executeUpdateOperation(update: delete) { (_) in }
//        service.executeQuery(query: SqliteDatabaseQuery<Todo>()) { (rows) in
//            XCTAssert(rows.count == 0, "The delete was unsuccessful.")
//        }
//    }
}
