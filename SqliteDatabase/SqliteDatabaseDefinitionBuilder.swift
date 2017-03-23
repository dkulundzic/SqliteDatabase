//
//  SqliteDatabaseDefinitionBuilder.swift
//  SqliteDatabase
//
//  Created by Domagoj Kulundzic on 23/03/2017.
//  Copyright © 2017 Farmeron. All rights reserved.
//

import Foundation

public class SqliteDatabaseDefinitionBuilder {
    
    // MARK: -
    // MARK: Private properties
    // MARK: -
    
    private var databaseDefinition: SqliteDatabaseBuildableDefinition
    
    // MARK: -
    // MARK: Initialisers
    // MARK: -
    
    public init() {
        self.databaseDefinition = SqliteDatabaseBuildableDefinition()
    }
    
    // MARK: -
    // MARK: API
    // MARK: -
    
    public func with(metadataDefinition: [String]) -> SqliteDatabaseDefinitionBuilder {
        databaseDefinition.metadataDefinition = metadataDefinition
        return self
    }
    
    public func with(tablesDefinition: [String]) -> SqliteDatabaseDefinitionBuilder {
        databaseDefinition.tablesDefinition = tablesDefinition
        return self
    }
    
    public func with(viewsDefinition: [String]) -> SqliteDatabaseDefinitionBuilder {
        databaseDefinition.viewsDefinition = viewsDefinition
        return self
    }
    
    public func with(indicesDefinition: [String]) -> SqliteDatabaseDefinitionBuilder {
        databaseDefinition.indicesDefinition = indicesDefinition
        return self
    }
    
    public func with(triggersDefinition: [String]) -> SqliteDatabaseDefinitionBuilder {
        databaseDefinition.triggersDefinition = triggersDefinition
        return self
    }
    
    /**
     Returns the internal SqliteDatabaseBuildableDefinition instance built by the SqliteDatabaseDefinitionBuilder.
     */
    public func build() -> SqliteDatabaseBuildableDefinition {
        return databaseDefinition
    }
    
    /**
     Resets the internal SqliteDatabaseBuildableDefinition instance to a empty one, ready for creation.
     */
    public func reset() {
        self.databaseDefinition = SqliteDatabaseBuildableDefinition()
    }
}
