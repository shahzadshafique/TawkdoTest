//
//  LoadingTableCellViewModel.swift
//  TawkCodingTest
//
//  Created by shahzadshafique on 30/10/2022.
//

struct LoadingTableCellViewModel {
    let showLoading: Bool
    
    init(showLoading: Bool) {
        self.showLoading = showLoading
    }
}

extension LoadingTableCellViewModel: CellViewModel {
    var cellIdentifier: String { LoadingTableCell.identifier }
    
}
