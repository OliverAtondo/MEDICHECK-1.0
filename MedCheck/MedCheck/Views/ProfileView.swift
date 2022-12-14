//
//  ProfileView.swift
//  MedCheck
//
//  Created by Ivan Lorenzana Belli on 11/12/22.
//

import SwiftUI

struct ProfileView: View {
    // MARK: App Storage
    @AppStorage("isInRegisterMode") var isRegisterView: Bool = false
    @AppStorage("has_fetch_mr") var haventFetchmr: Bool = true
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("is_google_user") var isGoogleUser: Bool = false
    @AppStorage("user_profile_url") var profileURL: URL?
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("user_UID") var userUID: String = ""
    // MARK: Medical Record Storage
    @AppStorage("user_profile_pic_data") var profilePicData: Data?
    @AppStorage("googleProfilePic") var photoURL: String = ""
    // MARK: Personal Info
    @AppStorage("full_name") var patientName: String = ""
    @AppStorage("user_email") var userEmail: String = ""
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
        GeometryReader{geometry in
            VStack(alignment:.leading){
                HStack{
                    Spacer()
                    Text("User Profile")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.biomedPrimary)
                        .padding(.bottom, -5)
                    Spacer()
                }
                HStack {
                    Spacer()
                    if isGoogleUser{
                        AsyncImage(url: URL(string: photoURL)) { image in
                            image.resizable()
                        } placeholder: {
                            Color.red
                            ProgressView()
                        }
                    }else{
                        ZStack{
                            if let image = UIImage(data: profilePicData!), let _ = profilePicData {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            }else{
                                Image("NullProfile")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            }
                        }
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .contentShape(Circle())
                        .padding(.top,25)
                        .padding(.bottom,25)
                    }
                    
                    Spacer()
                }
                Group{
                    Divider()
                        .padding(.horizontal,-30)
                    Text("Name")
                        .fontWeight(.bold)
                        .font(.title2)
                        .foregroundColor(Color.biomedPrimary)
                    Text(patientName)
                        .fontWeight(.bold)
                        .font(.title3)
                    Divider()
                        .padding(.horizontal,-30)
                    Text("Username")
                        .fontWeight(.bold)
                        .font(.title2)
                        .foregroundColor(Color.biomedPrimary)
                    Text(userNameStored)
                        .fontWeight(.bold)
                        .font(.title3)
                    Divider()
                        .padding(.horizontal,-30)
                    Text("Email")
                        .fontWeight(.bold)
                        .font(.title2)
                        .foregroundColor(Color.biomedPrimary)
                    Text(userEmail)
                        .fontWeight(.bold)
                        .font(.title3)
                }
                Divider()
                    .padding(.horizontal,-30)
            }
            .padding(.horizontal)
            
        }
    }

}
