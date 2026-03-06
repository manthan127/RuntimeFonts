//
//  FamilyModel.swift
//  RuntimeFonts
//
//  Created by Home on 06/03/26.
//

import Foundation

// This models is created for showing the list in this app
// only FontConvertible is actually needed to use the font itself
struct FamilyModel: Identifiable {
    let id = UUID()
    let familyName: String
    var fonts: [FontConvertible]
}

extension Array where Element == FamilyModel {
    mutating func add(_ newElement: Element) {
        if let ind = self.firstIndex(where: {$0.familyName == newElement.familyName}) {
            for newFont in newElement.fonts {
                if !self[ind].fonts.contains(newFont) {
                    self[ind].fonts.append(newFont)
                }
            }
        } else {
            append(newElement)
        }
    }
}
