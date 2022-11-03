//
//  UserDetailViewController.swift
//  TawkCodingTest
//
//  Created by shahzadshafique on 29/10/2022.
//

import UIKit
import SwiftUI

final class UserDetailViewController: UIViewController {
    private var contentView: UIHostingController<UserDetailView>!
    private let viewModel: UserDetailViewModel
    init(viewModel: UserDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = String(string: .viewDetail)
        setupHostViewController()
    }
    
    private func setupHostViewController() {
        contentView = UIHostingController(rootView: UserDetailView(viewModel: viewModel))
        addChild(contentView)
        view.addSubview(contentView.view)
        contentView.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        contentView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        contentView.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        contentView.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }

}
