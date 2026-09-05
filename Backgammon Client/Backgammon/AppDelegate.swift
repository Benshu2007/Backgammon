import UIKit

/// Enforces landscape-only orientation at the UIKit level, as a backstop
/// to the Info.plist "Supported interface orientations" setting.
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        supportedInterfaceOrientationsFor window: UIWindow?
    ) -> UIInterfaceOrientationMask {
        .landscape
    }
}
