//
//  SqliteDatabaseBuildableDefinition.swift
//  SqliteDatabase
//
//  Created by Domagoj Kulundzic on 23/03/2017.
//  Copyright © 2017 Farmeron. All rights reserved.
//

import Foundation

/**
 A class used to build custom database definitions on the fly.
 */
public class SqliteDatabaseBuildableDefinition: SqliteDatabaseDefinition {
    public var tablesDefinition: [String] = []
    public var metadataDefinition: [String] = []
    public var viewsDefinition: [String] = []
    public var triggersDefinition: [String] = []
    public var indicesDefinition: [String] = []
    public var postCreationStatements: [String] = []
}
