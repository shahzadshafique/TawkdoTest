//
//  UserListViewModel.swift
//  TawkCodingTest
//
//  Created by shahzadshafique on 29/10/2022.
//

import UIKit
import Combine

protocol UserListViewModelProtocol {
    var dataDidUpdate: ((Result<Void, Error>) -> Void)? { get set }
    var didChangeNetworkStatus: ((Bool) -> Void)? { get set }
    var numberOfItems: Int { get }
    func viewModelForItem(at indexPath: IndexPath) -> CellViewModel?
    func filter(for text: String)
    func register(for tableView: UITableView)
    func showDetail(at indexPath: IndexPath)
    func loadData()
    var requireLoading: Bool { get }
}

enum UserListAction {
    case detail(User, UserDataProviderProtocol)
}

final class UserListViewModel: UserListViewModelProtocol {
    private var userDataProvider: UserDataProviderProtocol
    var dataDidUpdate: ((Result<Void, Error>) -> Void)?
    var didChangeNetworkStatus: ((Bool) -> Void)?
    private let userActionHandler: (UserListAction) -> Void
    private(set) var state: Status = .idle
    private var isFiltering = false
    
    private var users: [User] = []
    private let reachabilityService = ReachabilityService.shared
    private var cancellable: AnyCancellable?
    
    private var filteredUsers: [User] = [] {
        didSet {
            self.dataDidUpdate?(.success(()))
        }
    }
    
    init(userDataProvider: UserDataProviderProtocol = UserDataProvider(),
         userActionHandler: @escaping (UserListAction) -> Void) {
        self.userDataProvider = userDataProvider
        self.userActionHandler = userActionHandler
        self.userDataProvider.delegate = self
        handleNetworkConnection()
    }
    
    var numberOfItems: Int {
        if isFiltering {
            return filteredUsers.count
        }
        
        return users.count
    }
    
    func viewModelForItem(at indexPath: IndexPath) -> CellViewModel? {
        return cellViewModelFactoryMethod(indexPath: indexPath)
    }
    
    func filter(for text: String) {
        guard !text.isEmpty else {
            filteredUsers.removeAll()
            isFiltering = false
            return
        }
        isFiltering = true
        filteredUsers = users.filter { $0.login.capitalized.starts(with: text.capitalized)}
    }
    
    func register(for tableView: UITableView) {
        tableView.register(UINib(nibName: InvertedTableCell.identifier, bundle: nil), forCellReuseIdentifier: InvertedTableCell.identifier)
        tableView.register(UINib(nibName: NormalTableCell.identifier, bundle: nil), forCellReuseIdentifier: NormalTableCell.identifier)
        tableView.register(UINib(nibName: NoteTableCell.identifier, bundle: nil), forCellReuseIdentifier: NoteTableCell.identifier)
        tableView.register(UINib(nibName: LoadingTableCell.identifier, bundle: nil), forCellReuseIdentifier: LoadingTableCell.identifier)
    }
    
    func showDetail(at indexPath: IndexPath) {
        guard indexPath.section == 0 else { return }
        let user = (isFiltering) ? filteredUsers[indexPath.row] : users[indexPath.row]
        userActionHandler(.detail(user, userDataProvider))
    }
    
    var requireLoading: Bool {
        state != .completed
    }
    
    func loadData() {
        guard state != .loading else { return }
        
        state = .loading
        var offset = 0
        if !users.isEmpty,
           let user = users.last {
            offset = user.id
        }
    
        userDataProvider.fetchUsers(offset: offset) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let users):
                self.handleSuccess(users: users)
                self.dataDidUpdate?(.success(()))
            case .failure(let error):
                self.state = .failed
                self.dataDidUpdate?(.failure(error))
            }
        }
    }
    
    private func handleSuccess(users: [User]) {
        guard !users.isEmpty else {
            state = .completed
            return
        }
        self.users.append(contentsOf: users)
        self.state = .idle
        
    }
    
    private func handleNetworkConnection() {
        cancellable = self.reachabilityService.objectWillChange.sink { [weak self] in
            guard let self = self else { return }
            self.didChangeNetworkStatus?(self.reachabilityService.isNetworkAvailable)
            if self.reachabilityService.isNetworkAvailable &&
               self.state == .failed {
                self.loadData()
            }
        }
    }
}

private extension UserListViewModel {
    func cellViewModelFactoryMethod(indexPath: IndexPath) -> CellViewModel {
        // TODO: Requirement is not clear here, if we have to show inverted on every forth element then note cell can accur at 4th index as well. As per requirement I am adding separate InvertedCell but it is not required.
        guard indexPath.section == 0 else {
            return createLoadingViewModel()
        }
        let index = indexPath.row
        let user = (isFiltering) ? filteredUsers[index] : users[index]
        
        let userDataModel = UserTableCellDataModel(title: user.login,
                                                   subTitle: String(string: .viewDetail),
                                                   imageURL: user.avatarURL ?? "",
                                                   showAsSeen: user.isSeen)
        if let notes = user.note,
           !notes.isEmpty {
            return NoteTableCellViewModel(userDataModel: userDataModel)
        } else if index % 4 == 0 {
            return InvertedTableCellViewModel(userDataModel: userDataModel)
        } else {
            return NormalTableCellViewModel(userDataModel: userDataModel)
        }
        
    }
    
    func createLoadingViewModel() -> CellViewModel {
        if state == .completed || isFiltering {
            return LoadingTableCellViewModel(showLoading: false)
        }
        
        loadData()
        return LoadingTableCellViewModel(showLoading: true)
    }
}

extension UserListViewModel: UserDataProviderDelegate {
    func didUpdate(user: User) {
        let index = users.firstIndex { $0.login == user.login }
        let indexFromFilters = filteredUsers.firstIndex { $0.login == user.login }
        
        if let index = index {
            users[index] = user
        }
        
        if let indexFromFilters = indexFromFilters {
            filteredUsers[indexFromFilters] = user
        }
        
        dataDidUpdate?(.success(()))
    }
}
