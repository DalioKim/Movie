
import Foundation
import UIKit

final class AppAppearance {
    static func setupAppearance() {
        UINavigationBar.appearance().barTintColor = .black
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
}

extension UINavigationController {
    @objc override public var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}
