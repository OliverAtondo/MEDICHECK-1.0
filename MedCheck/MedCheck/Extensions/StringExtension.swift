//
//  StringExtension.swift
//  MedCheck
//
//  Created by Ivan Lorenzana Belli on 09/12/22.
//

import Foundation

extension String{
    func isValidPhoneNumber() -> Bool{
        let pattern = "^\\d{10}$"
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
        return matches.count > 0
    }
    var doubleValue: Double{
        return Double(self) ?? 0
    }
}
