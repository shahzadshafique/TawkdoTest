//
//  UINavigationBar+Extension.swift
//  TawkCodingTest
//
//  Created by shahzadshafique on 02/11/2022.
//

import UIKit

extension UINavigationBar {
    static func applyDefaultAppearance() {
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
            UINavigationBar.appearance().tintColor = .black
        } else  {
            UINavigationBar.appearance().isTranslucent = false
            UINavigationBar.appearance().tintColor = .black
        }
        
    }
}
