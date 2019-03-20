
import UIKit

class ResultsTableViewController: UITableViewController {
    
    var tableName:String?
    var results = [Any](){
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FMDBDatabase.listTables { (success, fmresult, error) in
        
            if let fmresults = fmresult {
                var tables = [Any]()
                while fmresults.next() {
                    let name = fmresults.string(forColumn: "name") as Any
                    tables.append(name)
                }
                results = tables
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        if let item = results[indexPath.row] as? String {
            cell.textLabel?.text = "\(item)"
            cell.detailTextLabel?.text = ""
        }
        
        if let item = results[indexPath.row] as? Model {
            cell.textLabel?.text = "\(item.value1) \(item.value2)"
            cell.detailTextLabel?.text = "\(item.value3)"
        }
        
        return cell
    }

    /*
     * swipe to delete needs to know the correct model type or it won't work
     */
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = results[indexPath.row]
            results.remove(at: indexPath.row)
            deleteFromDatabase(item: item)
            return
        }
    }
    
    /*
     * this would only work if we knew the actual column names ahead of time.
     * this will not work in this generic example. 
     */
    private func deleteFromDatabase(item:Any) {
        
        var conditions = [WhereCondition]()
        
        if let item = item as? Model {
            let first = WhereCondition(column:"first", value:item.value1)
            let second = WhereCondition(column:"second", value:item.value2)
            let third = WhereCondition(column:"third", value:item.value3)
            let fourth = WhereCondition(column:"fourth", value:item.value4)
            conditions = [first, second, third, fourth]
        }
        
        guard conditions.count > 0 else { return }
        guard let table = tableName else { return }
        
        FMDBDatabase.delete(from: table, where: conditions) { (success, error) in
            if let error = error {
                showConfirmation(message: "", error: error)
                tableView.reloadData()
                return
            }
        }
    }
    
 
}
