//
//  NormalTableCellViewModel.swift
//  TawkCodingTest
//
//  Created by shahzadshafique on 29/10/2022.
//

import UIKit

struct NormalTableCellViewModel {
    private let userDataModel: CellDataModel
    private let imageProvider: ImageProviderProtocol
    var updateImage: ((Result<UIImage?, NetworkError>) -> Void)?
    
    init(userDataModel: CellDataModel,
         imageProvider: ImageProviderProtocol = ImageProvider()) {
        self.userDataModel = userDataModel
        self.imageProvider = imageProvider
    }
    
    var title: String {
        userTableCellDataModel?.title ?? ""
    }
    
    var subTitle: String {
        userTableCellDataModel?.subTitle ?? ""
    }
    
    var imageURL: String {
        userTableCellDataModel?.imageURL ?? ""
    }
    
    var showAsSeen: Bool {
        userTableCellDataModel?.showAsSeen ?? false
    }
    
    func loadImage() {
        imageProvider.fetchImage(url: imageURL) { result in
            updateImage?(result)
        }
    }
    
    private var userTableCellDataModel: UserTableCellDataModel? {
        userDataModel as? UserTableCellDataModel
    }
}

extension NormalTableCellViewModel: CellViewModel {
    var cellIdentifier: String {
        NormalTableCell.identifier
    }
}
