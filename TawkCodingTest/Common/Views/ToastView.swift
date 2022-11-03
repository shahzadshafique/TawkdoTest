//
//  ToastView.swift
//  TawkCodingTest
//
//  Created by shahzadshafique on 31/10/2022.
//

import UIKit

final class ToastView: UIView {
    private let viewModel: ToastViewModel
    private let label: UILabel =  {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    private var imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        return button
    }()
    
    init(viewModel: ToastViewModel, frame: CGRect) {
        self.viewModel = viewModel
        super.init(frame: frame)
        
        addSubview(label)
        addSubview(imageView)
        addSubview(closeButton)
        
        clipsToBounds = true
        layer.cornerRadius = 8
        layer.masksToBounds = true
        
        configure()
    }
    
    func configure() {
        label.text = viewModel.text
        imageView.image = viewModel.image
        closeButton.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        // TODO: this can be further extended for warning, info based on type in viewmodel 
        backgroundColor = .darkGray
        label.textColor = .white
        closeButton.tintColor = .white
        imageView.tintColor = .white
    }
    
    @objc private func handleClose() {
        viewModel.closeAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = CGRect(x: 8, y: 8, width: frame.height - 16, height: frame.height - 16)
        label.frame = CGRect(x: imageView.frame.maxX + 5, y: (frame.height - 22) / 2, width: frame.width - imageView.frame.maxX - 8, height: 22)
        closeButton.frame = CGRect(x: frame.width - 26, y: 2, width: 24, height: 24)
        
    }
    
    
}
