//
//  SqliteDatabaseDefinition.swift
//  SqliteDatabase
//
//  Created by Domagoj Kulundžić on 06/02/17.
//  Copyright © 2017 Farmeron. All rights reserved.
//

import Foundation

public protocol SqliteDatabaseDefinitionProtocol {
    var tableDefinition: [String] { get }
    var viewDefinition: [String] { get }
    var triggerDefinition: [String] { get }
    
    var customStatements:[String]? { get }
}
