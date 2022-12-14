//
//  Login.swift
//  MedCheck
//
//  Created by Ivan Lorenzana Belli on 30/11/22.
//

import SwiftUI
import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct LoginView: View{
    @EnvironmentObject var signupVM: SignUpViewModel
    
    // MARK: User Details
    @State var email = ""
    @State var pass = ""
    @State var visible = false
    // MARK: View Properties
    @State var createAccount:  Bool = false
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    @State var isLoading: Bool = false
    // MARK: UserDefaults
    @AppStorage("isInRegisterMode") var isRegisterView: Bool = false
    @AppStorage("isGoogleUser") var isGoogleUser: Bool = false
    @AppStorage("registerStatus") var registerStatus: Bool = false
    @AppStorage("log_status") var logStatus: Bool = false
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
        if registerStatus{
            MainScreenView()
        }else{
            ZStack(alignment: .topTrailing){
                GeometryReader{_ in
                    VStack(alignment: .leading){
                        Spacer()
                        HStack {
                            Spacer()
                            Image("LogoModificado")
                                .resizable()
                                .frame(width: 150, height: 126)
                            .scaledToFit()
                            Spacer()
                        }
                        VStack(alignment: .leading,spacing: 0){
                            Text("Welcome")
                                .font(.title)
                                .foregroundColor(Color.black)
                                .fontWeight(.bold)
                                .padding(.top,35)
                            Text("Login to your Account")
                                .font(.title)
                                .foregroundColor(Color.black)
                        }
                        
                        TextField("Email", text: self.$email)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).fill(Color.white))
                            .overlay(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color.black: Color.black,lineWidth:2))
                            .padding(.top,25)
                        HStack(spacing: 15){
                            VStack {
                                if self.visible{
                                    TextField("Password",text: self.$pass)
                                }else{
                                    SecureField("Password",text: self.$pass)
                                }
                            }
                            Button(action: {
                                self.visible.toggle()
                            }){
                                Image(systemName: self.visible ? "eye.slash.fill": "eye.fill")
                                    .foregroundColor(Color.black)
                            }
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).fill(Color.white))
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(self.pass != "" ? Color.black: Color.black,lineWidth:2))
                        .padding(.top,15)
                        HStack{
                            Spacer()
                            Button(action: {
                                // Codigo para recuperar contraseña
                                resetPassword()
                            }){
                                Text("Forgot password?")
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.biomedPrimary)
                            }
                        }
                        .padding(.top,15)
                        Button(action:{
                            // Codigo para el boton de Login
                            loginUser()
                        }){
                            Text("Login")
                                .foregroundColor(Color.white)
                                .fontWeight(.bold)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width-50)
                        }
                        .background(Color.biomedPrimary)
                        .cornerRadius(10)
                        .padding(.top,15)
                        LabelledDivider(label: "or")
                            .padding(.top,15)
                            .padding(.bottom,15)
                        Button {
                            signupVM.signUpWithGoogle()
                        } label: {
                            SocialLoginButton(image: "google", text: "Login with Google")
                        }
                        .padding(.bottom,35)
                        HStack{
                            Spacer()
                            Text("Don't have an account?")
                                .foregroundColor(Color.black)
                            Button(action: {
                                // Activa el cambio de vista
                                createAccount.toggle()
                            }){
                                Text("Sign up here")
                                    .foregroundColor(Color.biomedPrimary)
                                    .fontWeight(.bold)
                            }
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal,25)
                .overlay(content:{
                    LoadingView(show: $isLoading)
                })
                // MARK: Register View VIA Sheets
                .fullScreenCover(isPresented: $createAccount) {
                    RegisterView()
                }
            }
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled(true)
            .preferredColorScheme(.light)
            // MARK: Displaying Alert
            .alert(errorMessage, isPresented: $showError, actions: {})
        }
        
    }
    func loginUser(){
        isLoading = true
        closeKeyboards()
        Task{
            do{
                try await Auth.auth().signIn(withEmail: email, password: pass)
                print("User Found")
                try await fetchUser()
                try await fetchMedicalRecord()
                logStatus = true
            }catch{
                await setError(error)
            }
        }
    }
    // MARK: If User is Found then Fetching User Data From Firestore
    func fetchUser() async throws{
        guard let userID = Auth.auth().currentUser?.uid else {return}
        let user = try await Firestore.firestore().collection("Users").document(userID).getDocument(as: User.self)
        // MARK: UI Updating Must be Run On Main Thread
        await MainActor.run(body: {
            userUID = userID
            userNameStored = user.username
            profileURL = user.userProfileURL
        })
        
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
    func resetPassword(){
        Task{
            do{
                try await Auth.auth().sendPasswordReset(withEmail: email)
                print("Link Sent")
            }catch{
                await setError(error)
            }
        }
    }

    // MARK: Displaying Errors VIA Alert
    func setError(_ error: Error)async{
        // MARK: UI Must be Updated on Main Thread
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
            isLoading = false
        })
    }
}
struct Login_Previews: PreviewProvider {
    
    static var previews: some View {
        LoginView()
            .environment(\.colorScheme, .dark)
    }
}
