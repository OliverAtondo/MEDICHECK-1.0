//
//  User.swift
//  MedCheck
//
//  Created by Ivan Lorenzana Belli on 08/12/22.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift

struct User: Identifiable, Codable{
    @DocumentID var id: String?
    var username: String
    var userUID: String
    var userEmail: String
    var userProfileURL: URL
    
    enum CodingKeys: CodingKey{
        case id
        case username
        case userUID
        case userEmail
        case userProfileURL
    }
}
