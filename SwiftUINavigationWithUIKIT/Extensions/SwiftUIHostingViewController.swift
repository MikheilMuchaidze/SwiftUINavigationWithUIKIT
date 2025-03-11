import UIKit
import SwiftUI

final class SwiftUIHostedViewController<Content: View>: UIViewController {
    // MARK: - Hosting VC

    private let hostingController: UIHostingController<AnyView>

    // MARK: - Default Navigation Bar Left Items Visibility Properties

    private let displayBurgerMenuButton: Bool
    private let displayBottomMenu: Bool
    private let displayBackButton: Bool
    private var backButtonTitle: String

    // MARK: - View Modifier

    let navigationBarWorker = NavigationBarWorker()

    // MARK: - Init

    init(
        rootView: Content,
        title: String = "",
        navigationTitleSize: UINavigationItem.LargeTitleDisplayMode,
        displayBurgerMenuButton: Bool = false,
        displayBottomMenu: Bool = false,
        displayBackButton: Bool = true,
        backButtonTitle: String = "Baaaaack"
    ) {
        self.hostingController = UIHostingController(
            rootView: AnyView(
                rootView
                    .environmentObject(navigationBarWorker)
                    .navigationBarBackButtonHidden()
            )
        )
        self.displayBurgerMenuButton = displayBurgerMenuButton
        self.displayBottomMenu = displayBottomMenu
        self.displayBackButton = displayBackButton
        self.backButtonTitle = backButtonTitle
        super.init(nibName: nil, bundle: nil)
        self.title = title
        self.navigationItem.largeTitleDisplayMode = navigationTitleSize
        self.navigationItem.hidesBackButton = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHostingView()
        setupDefaultNavigationBarItems()
        self.navigationBarWorker.viewController = self
    }

    // MARK: - Setup

    private func setupHostingView() {
        view.addSubview(hostingController.view)
        addChild(hostingController)
        hostingController.didMove(toParent: self) // TODO: vnaxot ra aris

        hostingController.view.translatesAutoresizingMaskIntoConstraints = false

        let bottomAnchor = hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)

        if displayBottomMenu {
            bottomAnchor.constant -= 50 // Adjust height if bottom bar is displayed
        }

        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomAnchor
        ])
    }

    private func setupDefaultNavigationBarItems() {
        if displayBurgerMenuButton {
            addBurgerMenuButton()
            return
        }

        if displayBackButton {
            if navigationController?.viewControllers.count ?? 0 > 1 {
                addCustomBackButton()
            }
        } else {
            navigationItem.setHidesBackButton(true, animated: true)
        }
    }

    private func addCustomBackButton() {
        let backButton = UIButton(type: .infoLight)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.setImage(UIImage(systemName: "arrowshape.turn.up.backward.fill"), for: .normal)
        backButton.setTitle("Ukaaan", for: .normal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }

    @objc
    private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    private func addBurgerMenuButton() {
        navigationItem.leftBarButtonItems?.removeAll()
        let menuButton = UIButton(type: .custom)
        menuButton.addTarget(self, action: #selector(burgerMenuButtonTapped), for: .touchUpInside)
        menuButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        menuButton.setImage(UIImage(systemName: "list.bullet.clipboard.fill"), for: .normal)

        let burgerMenuBarButtonItem = UIBarButtonItem(customView: menuButton)

        navigationItem.setLeftBarButton(burgerMenuBarButtonItem, animated: false)
    }

    @objc
    private func burgerMenuButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension View {
    func embedInCustomController(
        title: String = "",
        navigationTitleSize: UINavigationItem.LargeTitleDisplayMode,
        displayBurgerMenuButton: Bool = false,
        displayBottomMenu: Bool = false,
        displayBackButton: Bool = true,
        backButtonTitle: String = "Baaaaack"
    ) -> UIViewController {
        SwiftUIHostedViewController(
            rootView: self,
            title: title,
            navigationTitleSize: navigationTitleSize,
            displayBurgerMenuButton: displayBurgerMenuButton,
            displayBottomMenu: displayBottomMenu,
            displayBackButton: displayBackButton,
            backButtonTitle: backButtonTitle
        )
    }
}
