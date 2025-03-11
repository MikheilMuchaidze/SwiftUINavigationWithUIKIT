import SwiftUI

final class Coordinator: ObservableObject {
    // MARK: - Private Properties

    private let navigationController: UINavigationController

    // MARK: - Init

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Start Method

    func start() {
        let firstVC = FirstView()
        firstVC.coordinator = self
        navigationController.pushViewController(firstVC, animated: true)
    }

    // MARK: - Navigation Methods

    func navigateToSecondView() {
        let secondView = SecondView()
            .environmentObject(self)
            .embedInCustomController(
                title: "Meoreee!",
                navigationTitleSize: .automatic
            )

        navigationController.pushViewController(secondView, animated: true)
    }

    func navigateToThirdView() {
        let thirdView = ThirdView()
            .environmentObject(self)
            .embedInCustomController(
                title: "Mesamee!",
                navigationTitleSize: .automatic,
                displayBurgerMenuButton: true
            )

        navigationController.pushViewController(thirdView, animated: true)
    }

    // MARK: - Utility Method

    func getNavController() -> UINavigationController {
        navigationController
    }

    func back() {
        navigationController.popViewController(animated: true)
    }
}
