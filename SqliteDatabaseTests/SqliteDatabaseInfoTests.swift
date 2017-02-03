//
//  SqliteDatabaseInfoTests.swift
//  SqliteDatabase
//
//  Created by Domagoj Kulundžić on 03/02/17.
//  Copyright © 2017 Farmeron. All rights reserved.
//

import XCTest
@testable import SqliteDatabase

class SqliteDatabaseInfoTests: XCTestCase {
    
    private var documentsDirectoryURL: URL!
    
    override func setUp() {
        documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    override func tearDown() {
        documentsDirectoryURL = nil
    }
    
    func test_InstanceCreation_NonEmptyUserIdentifier() {
        let info = SqliteDatabaseInfo(userIdentifier: "com.SqliteDatabase.Info")
        let path = info.getDatabasePath()
        
        let expectedPath = "\(documentsDirectoryURL.path)/com.SqliteDatabase.Info.db"
        XCTAssertEqual(path, expectedPath, "The path was not created properly.")
    }
    
    func test_InstanceCreation_EmptyUserIdentifier() {
        let info = SqliteDatabaseInfo(userIdentifier: "")
        let path = info.getDatabasePath()
        
        let expectedPath = "\(documentsDirectoryURL.path)/\(SqliteDatabaseInfo.defaultIdentifier).db"
        XCTAssertEqual(path, expectedPath, "The path was not created properly.")
    }
    
}
