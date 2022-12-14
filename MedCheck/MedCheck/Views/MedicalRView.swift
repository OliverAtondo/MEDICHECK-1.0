//
//  MedicalRView.swift
//  MedCheck
//
//  Created by Ivan Lorenzana Belli on 10/12/22.
//

import SwiftUI
import FirebaseFirestore
import Firebase
import FirebaseFirestore
import FirebaseAuth


struct MedicalRView: View {
    @State var isEditing: Bool = false
    @State var isLoading: Bool = false
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    // MARK: Medical Record Storage
    @AppStorage("googleProfilePic") var photoURL: String = ""
    @AppStorage("is_google_user") var isGoogleUser: Bool = false
    @AppStorage("user_profile_url") var profileURL: URL?
    // MARK: Personal Info
    @AppStorage("has_fetch_mr") var haventFetchmr: Bool = true
    @AppStorage("full_name") var patientName: String = ""
    @AppStorage("birth_date") var birthDate: String = ""
    @AppStorage("gender") var gender: String = ""
    @AppStorage("age") var age: String = ""
    @AppStorage("marital_Status") var maritalStatus: String = ""
    @AppStorage("address") var address: String = ""
    @AppStorage("phone_number") var cellphoneNumber: String = ""
    // MARK: Family History
    @AppStorage("diabetes") var hasDiabetes: Bool = false
    @AppStorage("obesity") var hasObesity: Bool = false
    @AppStorage("hearth_Disease") var hasHeartDisease: Bool = false
    @AppStorage("hypertension") var hasHypertension: Bool = false
    @AppStorage("lungDisease") var hasLungDisease: Bool = false
    @AppStorage("cancer") var hasCancer: Bool = false
    // MARK: Personal History 1
    @AppStorage("drinking_scale") var drinkingScale: String = ""
    @AppStorage("smoking_Scale") var smokingScale: String = ""
    @AppStorage("fitness_Scale") var fitnesScale: String = ""
    @AppStorage("sleeping_Hours") var sleepingHours: String = ""
    @AppStorage("work_study_hours") var workingStudingHours: String = ""
    @AppStorage("allergies") var allergies: String = ""
    // MARK: Personal History 2
    @AppStorage("illness") var illness: String = ""
    @AppStorage("illness_date") var illnessDate: String = ""
    @AppStorage("treatment") var treatment: String = ""
    @AppStorage("dose_of_medication") var doseOfMedication: String = ""
    
    var body: some View {
        GeometryReader{ geometry in
            VStack(alignment: .leading){
                HStack{
                    Spacer()
                    Text("Medical Record")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.biomedPrimary)
                        .padding(.bottom, -5)
                    Spacer()
                }
                Divider()
                    .padding(.horizontal,-20)
                ScrollView(showsIndicators: false){
                    VStack(alignment: .leading){
                        // MARK: Personal Information
                        personalInfo
                        // MARK: Family Health History
                        familyHealth
                        // MARK: Personal Health History non Patologic
                        nonPatologic
                        // MARK: Personal Health History Patologic
                        patologic
                            Spacer()
                        }
                    }
                    HStack{
                        Spacer()
                        Button(action: {
                            Task{
                                try await fetchMedicalRecord()
                                print("\(photoURL)")
                                print("\(isGoogleUser)")
                            }
                        }){
                            Text("Refresh Data")
                                .foregroundColor(Color.white)
                                .fontWeight(.bold)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width-50)
                        }
                        .background(Color.biomedPrimary)
                        .cornerRadius(10)
                        .disabled(!haventFetchmr)
                        Spacer()
                    }
                }
                
            }
            .padding(.horizontal)
        }
    // MARK: If User is Found then Fetching User Data From Firestore
    func fetchMedicalRecord() async throws{
        guard let userID = Auth.auth().currentUser?.uid else {return}
        let medicalre = try await Firestore.firestore().collection("MedicalRecords").document(userID).getDocument(as: MedicalRecord.self)
        // MARK: UI Updating Must be Run On Main Thread
        await MainActor.run(body: {
            self.patientName = medicalre.patientName
            self.birthDate = medicalre.birthDate
            self.gender = medicalre.gender
            self.age = medicalre.age
            self.maritalStatus = medicalre.maritalStatus
            self.address = medicalre.address
            self.cellphoneNumber = medicalre.cellphoneNumber
            self.hasDiabetes = medicalre.hasDiabetes
            self.hasObesity = medicalre.hasObesity
            self.hasHeartDisease = medicalre.hasHeartDisease
            self.hasHypertension = medicalre.hasHypertension
            self.hasLungDisease = medicalre.hasLungDisease
            self.hasCancer = medicalre.hasCancer
            self.drinkingScale = medicalre.drinkingScale
            self.smokingScale = medicalre.smokingScale
            self.fitnesScale = medicalre.fitnesScale
            self.sleepingHours = medicalre.sleepingHours
            self.workingStudingHours = medicalre.workingStudingHours
            self.allergies = medicalre.allergies
            self.illness = medicalre.illness
            self.illnessDate = medicalre.illnessDate
            self.treatment = medicalre.treatment
            self.doseOfMedication = medicalre.doseOfMedication
        })
        
    }
    var personalInfo: some View{
        Group{
            Text("1. Personal Information")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Color.biomedPrimary)
            VStack(alignment: .leading){
                HStack{
                    Text("Full name")
                        .bold()
                    Spacer()
                    Text(patientName)
                        .frame(minWidth: 0)
                        .border(0.2, .gray)
                }
                HStack{
                    Text("Address")
                        .bold()
                    Spacer()
                    Text(address)
                        .frame(minWidth: 0)
                        .border(0.2, .gray)
                }
                HStack{
                    Text("Phone number")
                        .bold()
                    Spacer()
                    Text(cellphoneNumber)
                        .frame(minWidth: 0)
                        .border(0.2, .gray)
                }
                HStack{
                    Text("Gender")
                        .bold()
                    Spacer()
                    Text(gender)
                        .frame(minWidth: 0)
                        .border(0.2, .gray)
                }
                HStack{
                    Text("Marital Status")
                        .bold()
                    Spacer()
                    Text(maritalStatus)
                        .frame(minWidth: 0)
                        .border(0.2, .gray)
                }
                HStack{
                    Text("Age")
                        .bold()
                    Spacer()
                    Text(age)
                        .frame(minWidth: 0)
                        .border(0.2, .gray)
                }
                HStack{
                    Text("Date of Birth")
                        .bold()
                    Spacer()
                    Text(birthDate)
                        .frame(minWidth: 0)
                        .border(0.2, .gray)
                }
            }
            .border(0.2, .gray)
        }
    }
    var familyHealth: some View{
        Group{
            Text("2. Family Health History")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Color.biomedPrimary)
            VStack{
                Toggle("Mellitus Diabetes", isOn: $hasDiabetes)
                    .fontWeight(.bold)
                    .disabled(true)
                    .tint(Color.biomedPrimary)
                Toggle("Obesity", isOn: self.$hasObesity)
                    .fontWeight(.bold)
                    .disabled(true)
                    .tint(Color.biomedPrimary)
                Toggle("Heart Disease", isOn: self.$hasHeartDisease)
                    .fontWeight(.bold)
                    .disabled(true)
                    .tint(Color.biomedPrimary)
                Toggle("Arterial Hypertension", isOn: self.$hasHypertension)
                    .fontWeight(.bold)
                    .disabled(true)
                    .tint(Color.biomedPrimary)
                Toggle("Cancer", isOn: self.$hasCancer)
                    .fontWeight(.bold)
                    .disabled(true)
                    .tint(Color.biomedPrimary)
                Toggle("Lung Disease", isOn: self.$hasLungDisease)
                    .fontWeight(.bold)
                    .disabled(true)
                    .tint(Color.biomedPrimary)
            }
            .border(0.2, .gray)
            .frame(minWidth: 0)
        }
    }
    var nonPatologic: some View{
        Group{
            Text("3. Non-Pathological Personal Background ")
                 .font(.title3)
                 .fontWeight(.bold)
                 .foregroundColor(Color.biomedPrimary)
            VStack(alignment: .leading){
                HStack{
                    Text("Smoking Scale")
                        .bold()
                    Spacer()
                    Text(smokingScale)
                        .border(0.2, .gray)
                }
                HStack{
                    Text("Drinking Scale")
                        .bold()
                    Spacer()
                    Text(drinkingScale)
                        .border(0.2, .gray)
                }
                
                HStack{
                    Text("Daily hours of physical activity Scale")
                        .bold()
                    Spacer()
                    Text(fitnesScale)
                        .border(0.2, .gray)
                }
                HStack{
                    Text("Daily Hours of Sleep")
                        .bold()
                    Spacer()
                    Text(sleepingHours)
                        .border(0.2, .gray)
                }
                HStack{
                    Text("Daily hours of physical activity Scale")
                        .bold()
                    Spacer()
                    Text(fitnesScale)
                        .border(0.2, .gray)
                }
                HStack{
                    Text("Hours dedicated to Work or Study")
                        .bold()
                    Spacer()
                    Text(workingStudingHours)
                        .border(0.2, .gray)
                }
                HStack{
                    Text("Allergies in General")
                        .bold()
                    Text(allergies)
                        .border(0.2, .gray)
                }
                
            }
            .border(0.2, .gray)
        }
    }
    var patologic: some View{
        Group{
            Text("4. Pathological Personal Background")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Color.biomedPrimary)
            VStack(alignment: .leading){
                HStack{
                    Text("High-Risk Illnes")
                        .bold()
                    Spacer()
                    Text(illness)
                        .frame(minWidth: 0)
                        .border(0.2, .gray)
                }
                HStack{
                    Text("Current Treatment")
                        .bold()
                    Spacer()
                    Text(treatment)
                        .frame(minWidth: 0)
                        .border(0.2, .gray)
                }
                HStack{
                    Text("Treatment Dose")
                        .bold()
                    Spacer()
                    Text(doseOfMedication)
                        .frame(minWidth: 0)
                        .border(0.2, .gray)
                }
                HStack{
                    Text("When did it begin")
                        .bold()
                    Spacer()
                    Text(illnessDate)
                        .frame(minWidth: 0)
                        .border(0.2, .gray)
                }
            }
            .frame(minWidth: 0)
            .border(0.2, .gray)
        }
    }
}

struct MedicalRView_Previews: PreviewProvider {
    static var previews: some View {
        MedicalRView()
    }
}
