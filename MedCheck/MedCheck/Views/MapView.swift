//
//  MapView.swift
//  MedCheck
//
//  Created by Ivan Lorenzana Belli on 10/12/22.
//

import SwiftUI
import MapKit
import CoreLocationUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct MapView: View {
    @StateObject var viewModel = MainScreenViewModel()
    @ObservedObject var service = Service()
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    // MARK: App Storage
    @AppStorage("has_fetch_mr") var haventFetchmr: Bool = true
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("is_google_user") var isGoogleUser: Bool = false
    @AppStorage("user_profile_url") var profileURL: URL?
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("user_UID") var userUID: String = ""
    // MARK: Medical Record Storage
    // MARK: Personal Info
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
        ZStack(alignment: .top){
            Map(coordinateRegion: $viewModel.region, showsUserLocation: true)
                .tint(.biomedPrimary)
                .ignoresSafeArea()
            LocationButton(.shareMyCurrentLocation){
                print("1ra \($viewModel.region)")
                viewModel.requestAllowOnceLocationPermission()
                let myJSON = [
                    "latitude": "\($viewModel.region.center.latitude.wrappedValue)",
                    "longitude": "\($viewModel.region.center.longitude.wrappedValue)",
                    "patientName": patientName,
                    "patientAge": age,
                    "patiendIllness": illness
                ]
                service.sendAlert(coordinates: myJSON)
                print(myJSON)
                confirmationMessage="Your location has been sent to the Server"
                showingConfirmation.toggle()
            }
            .foregroundColor(.white)
            .cornerRadius(8)
            .labelStyle(.titleOnly)
            .symbolVariant(.fill)
            .tint(.biomedPrimary)
            .padding(.top,20)
        }
        .alert("Alerta", isPresented: $showingConfirmation) {
            Button("OK") {}
        } message: {
            Text(confirmationMessage)
        }
    }

    
    
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}

