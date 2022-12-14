//
//  NumbersOnly.swift
//  MedCheck
//
//  Created by Ivan Lorenzana Belli on 09/12/22.
//

import Foundation
import SwiftUI

class NumbersOnly: ObservableObject{
    @Published var value = "" {
        didSet{
            let filtered = value.filter {$0.isNumber}
            if value != filtered{
                value = filtered
            }
        }
    }
}
