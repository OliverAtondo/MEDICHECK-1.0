//
//  Application.swift
//  MedCheck
//
//  Created by Ivan Lorenzana Belli on 05/12/22.
//

import SwiftUI

final class ApplicationUtility {
    static var rootViewController: UIViewController{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            return .init()
        }
        guard let root = screen.windows.first?.rootViewController else{
            return .init()
        }
        
        return root
    }
}
