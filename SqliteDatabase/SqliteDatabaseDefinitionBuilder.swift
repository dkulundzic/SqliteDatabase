//
//  SqliteDatabaseDefinitionBuilder.swift
//  SqliteDatabase
//
//  Created by Domagoj Kulundzic on 23/03/2017.
//  Copyright © 2017 Farmeron. All rights reserved.
//

import Foundation

/**
 A convenience class used to build SqliteDatabaseBuildableDefinition instances.
 */
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
    
    /**
     Attaches metadata definition data to the SqliteDatabaseBuildableDefinition.
     */
    public func with(metadataDefinition: [String]) -> SqliteDatabaseDefinitionBuilder {
        databaseDefinition.metadataDefinition = metadataDefinition
        return self
    }
    
    /**
     Attaches table definition data to the SqliteDatabaseBuildableDefinition.
     */
    public func with(tablesDefinition: [String]) -> SqliteDatabaseDefinitionBuilder {
        databaseDefinition.tablesDefinition = tablesDefinition
        return self
    }
    
    /**
     Attaches view definition data to the SqliteDatabaseBuildableDefinition.
     */
    public func with(viewsDefinition: [String]) -> SqliteDatabaseDefinitionBuilder {
        databaseDefinition.viewsDefinition = viewsDefinition
        return self
    }
    
    /**
     Attaches index definition data to the SqliteDatabaseBuildableDefinition.
     */
    public func with(indicesDefinition: [String]) -> SqliteDatabaseDefinitionBuilder {
        databaseDefinition.indicesDefinition = indicesDefinition
        return self
    }
    
    /**
     Attaches trigger definition data to the SqliteDatabaseBuildableDefinition.
     */
    public func with(triggersDefinition: [String]) -> SqliteDatabaseDefinitionBuilder {
        databaseDefinition.triggersDefinition = triggersDefinition
        return self
    }
    
    /**
     Attaches post creation statement data to the SqliteDatabaseBuildableDefinition.
     */
    public func with(postCreationStatements: [String]) -> SqliteDatabaseDefinitionBuilder {
        databaseDefinition.postCreationStatements = postCreationStatements
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
