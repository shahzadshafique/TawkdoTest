//
//  Strings.swift
//  TawkCodingTest
//
//  Created by shahzadshafique on 29/10/2022.
//

import Foundation

enum Strings: String {
    case viewDetail
    case errorTitle
    case generalErrorMessage
    case saveErrorMessage
    case saveSuccessMessage
    case networkErrorMessage
    case okButtonTitle
    case retryButtonTitle
    case following
    case followers
    case name
    case company
    case location
    case blog
    case email
    case note
    case users
    case save
}

extension String {
    init(string: Strings) {
        self = NSLocalizedString(string.rawValue, tableName:"Localizable", comment: "")
    }
}
