//
//  LoadingTableCell.swift
//  TawkCodingTest
//
//  Created by shahzadshafique on 30/10/2022.
//

import UIKit

final class LoadingTableCell: UITableViewCell {
    static let identifier = "LoadingTableCell"
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicatorView.startAnimating()
    }
}

extension LoadingTableCell: ConfigurableCell {
    func configure(viewModel: CellViewModel) {
        guard let loadingTableCellViewModel = viewModel as? LoadingTableCellViewModel else {
            return
        }
        
        if loadingTableCellViewModel.showLoading {
            activityIndicatorView.isHidden = false
            activityIndicatorView.startAnimating()
        } else {
            activityIndicatorView.isHidden = true
            activityIndicatorView.stopAnimating()
        }
        
        
    }
}

