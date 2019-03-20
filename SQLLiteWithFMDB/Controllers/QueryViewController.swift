
import UIKit

class QueryViewController: UIViewController {
    
    @IBOutlet weak var tableTextField: UITextField!
    @IBOutlet weak var searchByTextField: UITextField!
    @IBOutlet weak var whereTextField: UITextField!
    
    var tableViewController:ResultsTableViewController?
    var results = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Query Database"
        tableViewController = children.first as? ResultsTableViewController
    }
    
    @IBAction func runQuery(_ sender: Any) {
        if let table = tableTextField.text {
            
            var conditions:[WhereCondition]?
            if let search = searchByTextField.text,
                let text = whereTextField.text {
                if search.count > 0 && text.count > 0 {
                    let condition = WhereCondition(column:search, value:text)
                    conditions = [condition]
                }
            }
            
            FMDBDatabase.query(on: table, where: conditions) { (success, fmresult, error) in
                if let error = error {
                    showConfirmation(message:"" ,error: error)
                }
                
                results.removeAll()
                
                if let fmresult = fmresult {
                    createModel(fmresult: fmresult)
                }
            }
        }
    }
    
    private func createModel(fmresult: FMResultSet){
        
        while fmresult.next() {
            let first = fmresult.object(forColumnIndex: 1) as Any
            let second = fmresult.object(forColumnIndex: 2) as Any
            let third = fmresult.object(forColumnIndex: 3) as Any
            let fourth = fmresult.object(forColumnIndex: 4) as Any
            let model = Model(value1:first, value2:second, value3:third, value4:fourth)
            results.append(model)
        }
        
        fmresult.close()
        updateQueryListing()
    }
    
    private func updateQueryListing() {
        if let tableViewController = self.tableViewController,
            let tableName = tableTextField.text {
            tableViewController.tableName = tableName
            tableViewController.results = results
        }
    }

}
