//
//  UserListCoordinator.swift
//  TawkCodingTest
//
//  Created by shahzadshafique on 30/10/2022.
//

import UIKit

final class UserListCoordinator: Coordinator {
    
    private(set) var children: [Coordinator] = []
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = UserListViewModel { [weak self] action in
            switch action {
            case .detail(let user, let userDataProvider):
                self?.gotoUserDetail(user: user, dataProvider: userDataProvider)
            }
        }
        let userListViewController = UserListViewController(viewModel: viewModel)
        navigationController.viewControllers = [userListViewController]
    }
    
    func gotoUserDetail(user: User, dataProvider: UserDataProviderProtocol) {
        let userDetailCoordinator = UserDetailCoordinator(user: user,
                                                          dataProvider: dataProvider,
                                                          navigationController: navigationController)
        userDetailCoordinator.start()
        children.append(userDetailCoordinator)
    }
}
