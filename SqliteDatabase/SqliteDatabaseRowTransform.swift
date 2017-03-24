//
//  SqliteDatabaseRowTransform.swift
//  SqliteDatabase
//
//  Created by Domagoj Kulundžić on 03/02/17.
//  Copyright © 2017 InBetweeners. All rights reserved.
//

import Foundation

/**
 A transformation class whose aim's to transform an array of SqliteDatabaseRow
 to the specified type.
 */
open class SqliteDatabaseRowTransform<T> {
    private let transformation: ([SqliteDatabaseRow]) -> T
    
    public init(transformation: @escaping ([SqliteDatabaseRow]) -> T) {
        self.transformation = transformation
    }
    
    open func transform(rows: [SqliteDatabaseRow]) -> T {
        return self.transformation(rows)
    }
}
