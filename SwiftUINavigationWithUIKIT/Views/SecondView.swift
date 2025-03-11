import SwiftUI
import UIKit

struct SecondView: View {
    @EnvironmentObject private var coordinator: Coordinator
    @EnvironmentObject private var navigationBarWorker: NavigationBarWorker

    var body: some View {
        Text("Meoreee!")
            .onTapGesture {
                coordinator.navigateToThirdView()
            }
        HStack {
            Text("Add button!")
                .onTapGesture {
                    navigationBarWorker.addBurgerMenuButton {
                        print("Burger menu button tapped")
                    }
                }
            Spacer()
            Text("Remove button!")
                .onTapGesture {
                    navigationBarWorker.removeAllItemsFromNavigationBar()
                }
        }
        .padding(.horizontal, 50)
    }
}
