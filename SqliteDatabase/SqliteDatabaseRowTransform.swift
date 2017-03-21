//
//  SqliteDatabaseRowTransform.swift
//  SqliteDatabase
//
//  Created by Domagoj Kulundžić on 03/02/17.
//  Copyright © 2017 InBetweeners. All rights reserved.
//

import Foundation

open class SqliteDatabaseRowTransform<T> {
    private let transformation: ([SqliteDatabaseRow]) -> T
    
    public init(transformation: @escaping ([SqliteDatabaseRow]) -> T) {
        self.transformation = transformation
    }
    
    open func transform(rows: [SqliteDatabaseRow]) -> T {
        return self.transformation(rows)
    }
}
