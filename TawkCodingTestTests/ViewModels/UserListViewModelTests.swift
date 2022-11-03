//
//  UserListViewModelTests.swift
//  TawkCodingTestTests
//
//  Created by shahzadshafique on 02/11/2022.
//

import XCTest
@testable import TawkCodingTest

final class UserListViewModelTests: XCTestCase {
    private let userDataProvider = UserDataProviderMock()
    
    override func setUp() {
        userDataProvider.reset()
    }
    
    func testNmberOfItems() {
        var userAction: UserListAction?
        let viewModel = UserListViewModel(userDataProvider: userDataProvider) { action in
            userAction = action
        }
        
        viewModel.loadData()
        
        viewModel.showDetail(at: IndexPath(item: 0, section: 0))
        XCTAssertEqual(viewModel.numberOfItems,userDataProvider.userListToReturn.count)
        XCTAssertNotNil(userAction)
        
        viewModel.filter(for: "uskde-1")
        XCTAssertEqual(viewModel.numberOfItems, 11)
    }
    
    func testNmberOfItems_WithError() {
        userDataProvider.error = .noData
        let viewModel = UserListViewModel(userDataProvider: userDataProvider) {_ in}
        
        viewModel.loadData()
        
        XCTAssertEqual(viewModel.numberOfItems, 0)
    }
    
    func testFilters() {
        let viewModel = UserListViewModel(userDataProvider: userDataProvider) {_ in}
        
        viewModel.loadData()
        
        viewModel.filter(for: "uskde-1")
        XCTAssertEqual(viewModel.numberOfItems, 11)
        
        viewModel.filter(for: "uskde")
        XCTAssertEqual(viewModel.numberOfItems, 30)
        
        viewModel.filter(for: "adsfadsfasdf")
        XCTAssertEqual(viewModel.numberOfItems, 0)
        
    }
    
    func testRegisterCells() {
        let viewModel = UserListViewModel(userDataProvider: userDataProvider) {_ in}
        
        let tableView = UITableView()
        viewModel.register(for: tableView)
        
        XCTAssertNotNil(tableView.dequeueReusableCell(withIdentifier: InvertedTableCell.identifier))
        XCTAssertNotNil(tableView.dequeueReusableCell(withIdentifier: NormalTableCell.identifier))
        XCTAssertNotNil(tableView.dequeueReusableCell(withIdentifier: NoteTableCell.identifier))
        XCTAssertNotNil(tableView.dequeueReusableCell(withIdentifier: LoadingTableCell.identifier))
    }
    
    
    func testViewModelForItem() {
        let user1 = SampleData.createUserListArray().first!
        let user2 = SampleData.createUserListArray(notes: "Test notes").first!
        let user3 = SampleData.createUserListArray().last!
        
        userDataProvider.userListToReturn = [user1, user2, user3]
        
        let viewModel = UserListViewModel(userDataProvider: userDataProvider) {_ in}
        viewModel.loadData()
        
        let itemViewModel1 = viewModel.viewModelForItem(at: IndexPath(item: 0, section: 0))
        XCTAssertNotNil(itemViewModel1 as! InvertedTableCellViewModel)
        
        let itemViewModel2 = viewModel.viewModelForItem(at: IndexPath(item: 1, section: 0))
        XCTAssertNotNil(itemViewModel2 as! NoteTableCellViewModel)
        
        let itemViewModel3 = viewModel.viewModelForItem(at: IndexPath(item: 2, section: 0))
        XCTAssertNotNil(itemViewModel3 as! NormalTableCellViewModel)
        
        let itemViewModel4 = viewModel.viewModelForItem(at: IndexPath(item: 0, section: 1))
        XCTAssertNotNil(itemViewModel4 as! LoadingTableCellViewModel)
    }
    
    func testLoadData() {
        let viewModel = UserListViewModel(userDataProvider: userDataProvider) {_ in}
        
        viewModel.loadData()
        let expectedUserPerPage = userDataProvider.userListToReturn.count
        XCTAssertEqual(viewModel.numberOfItems, expectedUserPerPage)
        viewModel.loadData()
        XCTAssertEqual(viewModel.numberOfItems, expectedUserPerPage * 2)
        
        userDataProvider.userListToReturn = []
        
        viewModel.loadData()
        XCTAssertEqual(viewModel.numberOfItems, expectedUserPerPage * 2)
        
        XCTAssertFalse(viewModel.requireLoading)
    }
    
    func testDelegate() {
        var user1 = SampleData.createUserListArray().first!
        let user2 = SampleData.createUserListArray(notes: "Test notes").first!
        let user3 = SampleData.createUserListArray().last!
        
        userDataProvider.userListToReturn = [user1, user2, user3]
        let viewModel = UserListViewModel(userDataProvider: userDataProvider) {_ in}
        viewModel.loadData()
        
        var itemViewModel = viewModel.viewModelForItem(at: IndexPath(item: 0, section: 0))
        XCTAssertNotNil(itemViewModel as! InvertedTableCellViewModel)
        
        user1.note = "test notes"
        userDataProvider.delegate?.didUpdate(user: user1)
        
        itemViewModel = viewModel.viewModelForItem(at: IndexPath(item: 0, section: 0))
        XCTAssertNotNil(itemViewModel as! NoteTableCellViewModel)
    }
    
   
}
