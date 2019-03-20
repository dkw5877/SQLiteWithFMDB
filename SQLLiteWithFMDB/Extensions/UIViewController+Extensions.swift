

import UIKit.UIViewController

extension UIViewController {
    
    func showConfirmation(message:String, error:Error?){
        var message = message
        var title = "Success"
        if let error = error {
            title = "Error"
            message = "Error: \(error.localizedDescription)"
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
