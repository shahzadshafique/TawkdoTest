//
//  ToastViewModel.swift
//  TawkCodingTest
//
//  Created by shahzadshafique on 31/10/2022.
//

import UIKit

enum ToastType {
    case info
    case error
    case warning
}

final class ToastViewModel {
    let type: ToastType
    let text: String 
    let image: UIImage
    let closeAction: (() -> Void)
    
    init(type: ToastType,
         text: String,
         image: UIImage,
         closeAction: @escaping () -> Void) {
        self.type = type
        self.text = text
        self.image = image
        self.closeAction = closeAction
    }
}
