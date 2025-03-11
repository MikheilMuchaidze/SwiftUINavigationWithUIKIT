import SwiftUI

final class NavigationBarWorker: ObservableObject {
    // MARK: - Private Properties

    weak var viewController: UIViewController?

    // MARK: - Actions

    private var burgerMenuAction: (() -> Void)?

    // MARK: - Public Properties

    func removeAllItemsFromNavigationBar() {
        viewController?.navigationItem.setLeftBarButtonItems([], animated: false)
        viewController?.navigationItem.setRightBarButtonItems([], animated: false)
    }

    func addBurgerMenuButton(action: @escaping () -> Void) {
        let menuButton = UIButton(primaryAction: .init(handler: { _ in
            action()
        }))
        menuButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        menuButton.setImage(UIImage(systemName: "list.bullet.clipboard.fill"), for: .normal)

        let burgerMenuBarButtonItem = UIBarButtonItem(customView: menuButton)

        viewController?.navigationItem.setRightBarButton(burgerMenuBarButtonItem, animated: false)
    }

    @objc
    private func burgerMenuButtonTapped() {
        burgerMenuAction?()
    }
}
