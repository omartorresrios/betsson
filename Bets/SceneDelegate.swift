import UIKit
import BetsCore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let windowScene = (scene as? UIWindowScene) else { return }
		let window = UIWindow(windowScene: windowScene)
		let betService = RemoteBetService()
		let betRepository = BetRepository(service: betService)
		let oddsViewModel = OddsViewModel(repository: betRepository)
		let viewController = OddsViewController(viewModel: oddsViewModel)
		window.rootViewController = UINavigationController(rootViewController: viewController)
		self.window = window
		window.makeKeyAndVisible()
    }
}

