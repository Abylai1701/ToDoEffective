import UIKit
import Foundation

extension UIView {
    func addSubviews(_ views : UIView...) -> Void {
        views.forEach { (view) in
            self.addSubview(view)
        }
    }
}
extension UICollectionViewCell {
    static var cellId: String {
        return String(describing: self)
    }
}
extension UITableViewCell {
    static var cellId: String {
        return String(describing: self)
    }
}
