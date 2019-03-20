//
//  FMDBDatabase.swift
//  SQLLiteWithFMDB
//
//  Created by user on 3/13/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation

/*
 * @description defines a basic generic data object
 */
public struct Model {
    let value1:Any
    let value2:Any
    let value3:Any
    let value4:Any
}

public struct TableColumn{
    let name:String
    let type:String
}

public struct WhereCondition{
    let column:String
    let value:Any
}

class FMDBDatabase {

    /*
     * @description defines completion closures for database calls
     */
    public typealias Completion = ((Bool, Error?)-> Void)
    
    public typealias ResultCompletion = ((Bool, FMResultSet?, Error?)-> Void)
    
    /*
     * @description singleton to access the database
     */
    static let sharedDatabase:FMDatabase = {
        let fileURL = try! FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("test.sqlite")
        let database = FMDatabase(url: fileURL)
        return database
    }()
    
    /*
     * @description singleton to access a serial queue for updating the database
     */
    static let sharedQueue: FMDatabaseQueue = {
        let documents = try! FileManager.default
        .url(for:.applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let fileURL = documents.appendingPathComponent("test.sqlite")
        return FMDatabaseQueue(path: fileURL.path)!
    }()
    
    /*
     * @description: creates a table with the specified list of columns and value types
     * @note statement example  e.g."CREATE TABLE IF NOT EXISTS table_name (Title Text, Author Text, PublicationDate Date)"
     * @param table name of the table to create
     * @param columns list of TableColumn values to create the columns
     * @param completion closure to be called when create is complete
     */
    static func create(table:String, columns:[TableColumn], completion:Completion) {
        var sqlStatement = "CREATE TABLE IF NOT EXISTS \(table) (ID Integer Primary key AutoIncrement,"
        
        for (index, column) in columns.enumerated() {
            sqlStatement += " \(column.name) \(column.type)"
            sqlStatement += (index == columns.count - 1) ? ");" :","
        }
        
        FMDBDatabase.update(sqlStatement: sqlStatement, completion: completion)
     
    }
    
    /*
     * @description: All transactions in FMDM are an UPDATE if they are not a QUERY, this
     * helper method is called by the CREATE, INSERT, and DELETE functions
     * @param sqlStatement the complete SQL statement to execute
     * @param values list of TableColumn or WhereConditions values to use in update
     * @param completion closure to be called when update is complete
     */
    private static func update(sqlStatement:String, values:[Any]? = nil, completion:Completion) {
        print(#function, sqlStatement, values as Any)
        
        sharedQueue.inDeferredTransaction { (db, rollback) in
            do {
                if !sharedDatabase.isOpen {
                    sharedDatabase.open()
                }
                try sharedDatabase.executeUpdate(sqlStatement, values: values)
                completion(true, nil)
                sharedDatabase.close()
            } catch {
                print("failed: \(error.localizedDescription)")
                completion(false, error)
                sharedDatabase.close()
            }
        }
    }
    
    /*
     * @description: Insert an array of values in the given table
     * @warning this assumes the first field is an autoincrementing value
     * @note statement example "INSERT INTO table_name VALUES (NULL, ?, ?, ?)"
     * @param values array of items to insert
     * @param table SQL table name to insert values into
     * @param completion closure to be called when insert is complete
     */
    static func insert(values: [Any], into table:String, completion:Completion) {
        
        /* we need to specify NULL when using VALUES for any autoincremented keys */
        var sqlStatement = "INSERT OR REPLACE INTO \(table) VALUES (NULL"
        
        for (index, _) in values.enumerated() {
            sqlStatement += (index == values.count - 1) ? ", ?)" :", ?"
        }
        
        FMDBDatabase.update(sqlStatement: sqlStatement, values:values, completion: completion)
    }
    
    /*
     * @description: delete a row of data from a given table based on conditions
     * @note statement example "DELETE FROM table_name WHERE column_name = ?"
     * @param table SQL table name to insert values into
     * @param completion closure to be called when delete is complete
     */
    static func delete(from table:String, where conditions:[WhereCondition], completion:Completion) {
        
        var sqlStatement = "DELETE FROM \(table)"
        
        var values = [Any]()
        
        sqlStatement += " WHERE"
        for (index, condition) in conditions.enumerated() {
            values.append(condition.value)
            sqlStatement += " \(condition.column) = ?"
            sqlStatement += (index == conditions.count - 1) ? "" :","
        }
        FMDBDatabase.update(sqlStatement: sqlStatement, values:values,  completion: completion)
    }

    /*
     * @description: query the given table based on conditions provided
     * @note statement example "SELECT * FROM table_name WHERE "
     * @param table SQL table name to insert values into
     * @param completion closure to be called when query is complete
     */
    static func query(on table:String, where conditions:[WhereCondition]? = nil, completion:ResultCompletion){
        var sqlStatement = "SELECT * FROM \(table)"

        var values = [Any]()
        if let conditions = conditions {
            sqlStatement += " WHERE"
            for (index, condition) in conditions.enumerated() {
                values.append(condition.value)
                sqlStatement += " \(condition.column) = ?"
                sqlStatement += (index == conditions.count - 1) ? "" :","
            }
        }
        
        sharedQueue.inDeferredTransaction { (db, rollback) in
            do {
                if !sharedDatabase.isOpen {
                    sharedDatabase.open()
                }
                let fmresult = try sharedDatabase.executeQuery(sqlStatement, values: values)
                completion(true, fmresult, nil)
                sharedDatabase.close()
            } catch {
                rollback.pointee = true
                completion(false, nil, error)
                sharedDatabase.close()
            }
        }
    }
    
    /*
     * @description:
     * @note statemtment example "DROP TABLE IF EXISTS table_name"
     * @param table name of the table to drop
     * @param completion closure to be called when drop is complete
     */
    static func drop(table:String, completion:Completion) {
        let sqlStatement = "DROP TABLE IF EXISTS \(table)"
        FMDBDatabase.update(sqlStatement: sqlStatement, completion: completion)
    }
    
    /*
     * @description: list all tables in the database
     * @note statemtment example ""SELECT name FROM sqlite_master WHERE type='table' ORDER BY name"
     */
    static func listTables(completion:ResultCompletion) {
        let sqlStatement = "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name;"
        sharedQueue.inDeferredTransaction { (db, rollback) in
            do {
                sharedDatabase.open()
                let fmresult = try sharedDatabase.executeQuery(sqlStatement, values: nil)
                completion(true, fmresult, nil)
                sharedDatabase.close()
            } catch {
                rollback.pointee = true
                print("failed: \(error.localizedDescription)")
                completion(false, nil, error)
                sharedDatabase.close()
            }
        }
    }
    
}
