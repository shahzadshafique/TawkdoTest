//
//  UserDetailCoordinator.swift
//  TawkCodingTest
//
//  Created by shahzadshafique on 30/10/2022.
//

import UIKit

final class UserDetailCoordinator: Coordinator {
    
    private(set) var children: [Coordinator] = []
    private let navigationController: UINavigationController
    private let user: User
    private let dataProvider: UserDataProviderProtocol
    
    init(user: User,
         dataProvider: UserDataProviderProtocol,
         navigationController: UINavigationController) {
        self.user = user
        self.dataProvider = dataProvider
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = UserDetailViewModel(user: user, userDataProvider: dataProvider)
        let userDetailViewController = UserDetailViewController(viewModel: viewModel)
        navigationController.pushViewController(userDetailViewController, animated: true)
    }
}

