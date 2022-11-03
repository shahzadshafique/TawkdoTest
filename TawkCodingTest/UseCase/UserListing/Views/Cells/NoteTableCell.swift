//
//  NoteTableCell.swift
//  TawkCodingTest
//
//  Created by shahzadshafique on 29/10/2022.
//

import UIKit

final class NoteTableCell: UITableViewCell {
    static let identifier = "NoteTableCell"
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

extension NoteTableCell: ConfigurableCell {
    func configure(viewModel: CellViewModel) {
        guard var noteCellViewModel = viewModel as? NoteTableCellViewModel else {
            return
        }
        
        titleLabel.text = noteCellViewModel.title
        subTitleLabel.text = noteCellViewModel.subTitle
        noteCellViewModel.updateImage = { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let image):
                self.updateImage(image: image)
            case .failure(_): break
            }
        }
        
        noteCellViewModel.loadImage()
        
        if noteCellViewModel.showAsSeen {
            containerView.alpha = 0.5
        }
    }
    
    private func updateImage(image: UIImage?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if let image = image {
                self.cellImagView.image = image
            }
        }
    }
}
