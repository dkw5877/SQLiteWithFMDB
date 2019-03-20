
import UIKit

class InsertRecordViewController: UIViewController {

    @IBOutlet weak var tableName: UITextField!
    @IBOutlet weak var value1: UITextField!
    @IBOutlet weak var value2: UITextField!
    @IBOutlet weak var value3: UITextField!
    @IBOutlet weak var value4: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         title = "Insert Record"
    }
    
    
    @IBAction func insertRecord(_ sender: Any) {
        
        if let tableName = tableName.text,
            let values = createModel() {
            if tableName.count > 0 {
                FMDBDatabase.insert(values: values, into: tableName) { (success, error) in
                    showConfirmation(message: "Record inserted", error: error)
                }
            }
        }
    }
    
    //remove any nil strings and any empty strings
    private func createModel() -> [String]? {
        let values = [value1.text, value2.text, value3.text, value4.text]
        let result:[String] = values.compactMap{ $0 }.filter{ $0.count > 0}
        return result.count > 0 ? result : nil
    }
    
}
