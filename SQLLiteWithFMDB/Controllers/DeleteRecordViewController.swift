//
//  DeleteRecordViewController.swift
//  SQLLiteWithFMDB
//
//  Created by user on 3/18/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class DeleteRecordViewController: UIViewController {

    @IBOutlet weak var tableName: UITextField!
    
    @IBOutlet weak var column1: UITextField!
    @IBOutlet weak var column2: UITextField!
    @IBOutlet weak var column3: UITextField!
    @IBOutlet weak var column4: UITextField!
    
    @IBOutlet weak var value1: UITextField!
    @IBOutlet weak var value2: UITextField!
    @IBOutlet weak var value3: UITextField!
    @IBOutlet weak var value4: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func deleteRecords(_ sender: Any) {
      
        if let table = tableName.text, let conditions = createWhereConditions() {
            FMDBDatabase.delete(from: table, where: conditions) { (success, error) in
                showConfirmation(message: "Records deleted", error: error)
            }
        }
    }
    
    private func createWhereConditions() ->[WhereCondition]? {
        
        var conditions = [WhereCondition]()
        
        if let column1Name = column1.text,
            let column1Value = value1.text {
            if column1Name.count > 0 && column1Value.count > 0 {
                let condition = WhereCondition(column:column1Name, value:column1Value)
                conditions.append(condition)
            }
        }
        
        if let column2Name = column2.text,
            let column2Value = value2.text {
            if column2Name.count > 0 && column2Value.count > 0 {
                let condition = WhereCondition(column:column2Name, value:column2Value)
                conditions.append(condition)
            }
        }
        
        if let column3Name = column3.text,
            let column3Value = value3.text {
            if column3Name.count > 0 && column3Value.count > 0 {
                let condition = WhereCondition(column:column3Name, value:column3Value)
                conditions.append(condition)
            }
        }
        
        if let column4Name = column4.text,
            let column4Value = value4.text {
            if column4Name.count > 0 && column4Value.count > 0 {
                let condition = WhereCondition(column:column4Name, value:column4Value)
                conditions.append(condition)
            }
        }
        
        return conditions.count > 0 ? conditions : nil
    }
    
    @IBAction func dropTable(_ sender: Any) {
        if let table = tableName.text {
            FMDBDatabase.drop(table: table) { (success, error) in
                showConfirmation(message: "Table Dropped!", error: error)
            }
        }
    }
    

}
