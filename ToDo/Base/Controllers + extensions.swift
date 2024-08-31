import Foundation
import UIKit

enum AlertMessageType: String {
    case error = "Ошибка"
    case none = "Внимание"
    case null = ""
}

extension UIViewController {
    func inNavigation() -> UIViewController {
        let navController = UINavigationController(rootViewController: self)
        navController.setNavigationBarHidden(true, animated: false)
        return navController
    }
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
    func showErrorMessage(messageType: AlertMessageType,
                          _ message: String,
                          completion: (() -> Void)? = nil) {
        
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: messageType.rawValue, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                if let completionHandler = completion {
                    self.dismiss(animated: true, completion: nil)
                    completionHandler()
                }
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showSuccessMessage(completion: (() -> ())? = nil) -> Void {
        let alertController = UIAlertController(title: "Успешно", message: nil, preferredStyle: .alert)
        self.present(alertController, animated: true, completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                alertController.dismiss(animated: true) {
                    if let completionHandler = completion {
                        completionHandler()
                    }
                }
            }
        })
    }
    
    func showSubmitMessage(messageType: AlertMessageType,
                           _ message: String,
                           completion: (@escaping () -> Void)) {
        let alertController = UIAlertController(title: messageType.rawValue, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Да", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
            completion()
        }

        let cancelAction = UIAlertAction(title: "Нет", style: .default, handler: nil)

        alertController.addAction(okAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }
}

