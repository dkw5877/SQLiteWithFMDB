
import UIKit

class CreateTableViewController: UIViewController {

    @IBOutlet weak var tableName: UITextField!
    @IBOutlet weak var column1Name: UITextField!
    @IBOutlet weak var column1Type: UITextField!
    @IBOutlet weak var column2Name: UITextField!
    @IBOutlet weak var column2Type: UITextField!
    @IBOutlet weak var column3Name: UITextField!
    @IBOutlet weak var column3Type: UITextField!
    @IBOutlet weak var column4Name: UITextField!
    @IBOutlet weak var column4Type: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Table"
    }
    
    @IBAction func createTable(_ sender: Any) {
        if let table = tableName.text {
            if  let columns = createTableColumns(){
                FMDBDatabase.create(table: table, columns: columns) { (success, error) in
                    showConfirmation(message: "Table Created", error: error)
                }
            }
        }
    }
    
    private func createTableColumns() -> [TableColumn]? {
        var columns = [TableColumn]()
        
        if let column1Name = column1Name.text,
            let column1Type = column1Type.text {
            if column1Name.count > 0 && column1Type.count > 0 {
                let column = TableColumn(name:column1Name, type:column1Type)
                columns.append(column)
            }
        }
        
        if let column2Name = column2Name.text,
            let column2Type = column2Type.text {
            if column2Name.count > 0 && column2Type.count > 0 {
                let column = TableColumn(name:column2Name, type:column2Type)
                columns.append(column)
            }
        }
        
        if let column3Name = column3Name.text,
            let column3Type = column3Type.text {
            if column3Name.count > 0 && column3Type.count > 0 {
                let column = TableColumn(name:column3Name, type:column3Type)
                columns.append(column)
            }
        }
        
        if let column4Name = column4Name.text,
            let column4Type = column4Type.text {
            if column4Name.count > 0 && column4Type.count > 0 {
                let column = TableColumn(name:column4Name, type:column4Type)
                columns.append(column)
            }
        }
            
        return columns.count > 0 ? columns : nil
    }
    
}
