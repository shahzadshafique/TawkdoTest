//
//  UserTableCellDataModel.swift
//  TawkCodingTest
//
//  Created by shahzadshafique on 29/10/2022.
//

// Using only one data model for all cells as data is same, but it can be extended for different type of data
struct UserTableCellDataModel: CellDataModel {
    let title: String
    let subTitle: String
    let imageURL: String
    let showAsSeen: Bool
}
