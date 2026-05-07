import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var blurView: UIVisualEffectView?  // ← Bunu əlavə et

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .white
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
    }

    // ← Bu iki funksiyanı əlavə et
    func sceneWillResignActive(_ scene: UIScene) {
        let blur = UIBlurEffect(style: .dark)
        blurView = UIVisualEffectView(effect: blur)
        blurView?.frame = window?.bounds ?? .zero
        window?.addSubview(blurView!)
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        blurView?.removeFromSuperview()
        blurView = nil
    }
}
