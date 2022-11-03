//
//  UserListViewController.swift
//  TawkCodingTest
//
//  Created by shahzadshafique on 29/10/2022.
//

import UIKit
import Combine

final class UserListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var viewModel: UserListViewModelProtocol
    let searchController = UISearchController()
    private var toastView: ToastView?
    
    init(viewModel: UserListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: "UserListViewController", bundle: Bundle.main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = String(string: .users)
        viewModel.register(for: tableView)
        viewModel.dataDidUpdate = { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.setupSearchBar()
                    self.tableView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.handleError(error: error)
                }
            }
        }
        
        viewModel.didChangeNetworkStatus = { [weak self] isConnected in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if !isConnected {
                    self.showToastView()
                } else {
                    self.toastView?.removeFromSuperview()
                    self.toastView = nil
                }
            }
        }
        
        viewModel.loadData()
        if viewModel.numberOfItems > 0 {
            setupSearchBar()
        }
    }
    
    private func showToastView() {
        guard self.toastView == nil, let image = UIImage(systemName: "wifi.slash") else { return }
        
        let closeAction = { [weak self] in
            guard let self = self else { return }
            self.toastView?.removeFromSuperview()
            self.toastView = nil
        }
        
        let frame = CGRect(x: 10, y: view.frame.height, width: view.frame.width - 20 , height: 50)
        toastView = ToastView(viewModel: ToastViewModel(type: .error, text: String(string: .networkErrorMessage), image: image, closeAction: closeAction), frame: frame)
        
        if let toastView = toastView {
            view.addSubview(toastView)
            
            UIView.animate(withDuration: 0.25) {
                toastView.frame = CGRect(x: 10, y: self.view.frame.height - 75, width: self.view.frame.width - 20 , height: 50)
            }
        }
    }
    
    private func handleError(error: Error) {
        guard toastView == nil else {
            return
        }
        
        //TODO: This error should be handled under error management component/class.
        self.displayAlert(title: error.title, message: error.message)
    }
    
    private func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: String(string: .okButtonTitle), style: .default) { action in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(okButton)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    private func setupSearchBar() {
        guard navigationItem.searchController == nil else {
            return
        }
        
        searchController.searchBar.backgroundColor = .white
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

extension UserListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        
        viewModel.filter(for: text)
    }
}

extension UserListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.showDetail(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.section == 0 else {
            return (viewModel.requireLoading) ? 40 : 0
        }
        
        return 80
    }
}

extension UserListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.numberOfItems
        }
        
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cellViewModel = viewModel.viewModelForItem(at: indexPath) else {
            return UITableViewCell()
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: cellViewModel.cellIdentifier, for: indexPath)
        if let configurableCell = cell as? ConfigurableCell {
            configurableCell.configure(viewModel: cellViewModel)
        }
        
        return cell
    }
}
