//
//  MedicalRecord.swift
//  MedCheck
//
//  Created by Ivan Lorenzana Belli on 09/12/22.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift

struct MedicalRecord: Identifiable, Codable{
    @DocumentID var id: String?
    
    var userUID: String
    // MARK: Personal Info
    var patientName: String
    var birthDate: String
    var gender: String
    var age: String
    var maritalStatus: String
    var address: String
    var cellphoneNumber: String
    // MARK: Family History
    var hasDiabetes: Bool
    var hasObesity: Bool
    var hasHeartDisease: Bool
    var hasHypertension: Bool
    var hasLungDisease: Bool
    var hasCancer: Bool
    // MARK: Personal History 1
    var drinkingScale: String
    var smokingScale: String
    var fitnesScale: String
    var sleepingHours: String
    var workingStudingHours: String
    var allergies: String
    // MARK: Personal History 2
    var illness: String
    var illnessDate: String
    var treatment: String
    var doseOfMedication: String
    
    enum CodingKeys: String, CodingKey{
        case id
        case userUID
        // MARK: Personal Info
        case patientName
        case birthDate
        case gender
        case age
        case maritalStatus
        case address
        case cellphoneNumber
        // MARK: Family History
        case hasDiabetes
        case hasObesity
        case hasHeartDisease
        case hasHypertension
        case hasLungDisease
        case hasCancer
        // MARK: Personal History 1
        case drinkingScale
        case smokingScale
        case fitnesScale
        case sleepingHours
        case workingStudingHours
        case allergies
        // MARK: Personal History 2
        case illness
        case illnessDate
        case treatment
        case doseOfMedication
    }
    
}

