import Foundation
import UIKit

public class LoaderView {

    internal static var spinner: UIActivityIndicatorView?
    internal static var activityLabel = UILabel(frame: CGRect.init(x: 0, y: 0, width: 200, height: 200))

    public static func show() {
        DispatchQueue.main.async {
            NotificationCenter.default.addObserver(self, selector: #selector(update), name: UIDevice.orientationDidChangeNotification, object: nil)
            if spinner == nil, let window = UIApplication.shared.keyWindow {
                let frame = UIScreen.main.bounds
                let spinner = UIActivityIndicatorView(frame: frame)
                spinner.backgroundColor = UIColor.black.withAlphaComponent(0.0)
                if #available(iOS 13.0, *) {
                    spinner.style = .large
                } else {
                    // Fallback on earlier versions
                }
                spinner.tintColor = .blue
                spinner.color = .blue
                window.addSubview(spinner)
                spinner.startAnimating()
                self.spinner = spinner
            }
        }
    }

    public static func hide() {
        DispatchQueue.main.async {
            guard let spinner = spinner else { return }
            spinner.stopAnimating()
            spinner.removeFromSuperview()
            self.spinner = nil
        }
    }

    @objc public static func update() {
        DispatchQueue.main.async {
            if spinner != nil {
                hide()
                show()
            }
        }
    }
}

