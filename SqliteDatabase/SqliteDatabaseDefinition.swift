//
//  SqliteDatabaseDefinition.swift
//  SqliteDatabase
//
//  Created by Domagoj Kulundzic on 23/03/2017.
//  Copyright © 2017 Farmeron. All rights reserved.
//

import Foundation

public protocol SqliteDatabaseDefinition {
    var metadataDefinition: [String] { get }
    var tablesDefinition: [String] { get }
    var viewsDefinition: [String] { get }
    var triggersDefinition: [String] { get }
    var indicesDefinition: [String] { get }
}

extension SqliteDatabaseDefinition {
    public var metadataDefinition: [String] { return [] }
    public var viewsDefinition: [String] { return [] }
    public var triggersDefinition: [String] { return [] }
    public var indicesDefinition: [String] { return [] }
}
