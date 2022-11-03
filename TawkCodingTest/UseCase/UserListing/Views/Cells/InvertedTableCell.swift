//
//  InvertedTableCell.swift
//  TawkCodingTest
//
//  Created by shahzadshafique on 29/10/2022.
//

import UIKit

final class InvertedTableCell: UITableViewCell {
    static let identifier = "InvertedTableCell"
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var cellImagView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.borderColor = UIColor.darkGray.cgColor
        containerView.layer.borderWidth = 2.0
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
        subTitleLabel.text = nil
        cellImagView.image = UIImage(systemName: "person.circle")
        containerView.alpha = 1.0
        super.prepareForReuse()
    }
}

extension InvertedTableCell: ConfigurableCell {
    func configure(viewModel: CellViewModel) {
        guard var invertedCellViewModel = viewModel as? InvertedTableCellViewModel else {
            return
        }
        
        titleLabel.text = invertedCellViewModel.title
        subTitleLabel.text = invertedCellViewModel.subTitle
        invertedCellViewModel.updateImage = { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let image):
                self.updateImage(image: image)
            case .failure(_): break
            }
        }
        
        invertedCellViewModel.loadImage()
        
        if invertedCellViewModel.showAsSeen {
            containerView.alpha = 0.5
        }
        
    }
    
    private func updateImage(image: UIImage?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if let image = image {
                self.cellImagView.image = image.invertedImage()
            }
        }
    }
    
}
