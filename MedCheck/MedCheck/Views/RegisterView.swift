//
//  Signup.swift
//  MedCheck
//
//  Created by Ivan Lorenzana Belli on 30/11/22.
//

import Foundation
import SwiftUI
import PhotosUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct RegisterView: View {
    @EnvironmentObject var signupVM: SignUpViewModel
    // MARK: User Details
    @State var email = ""
    @State var pass = ""
    @State var username = ""
    @State var userProfilePicData: Data?
    @State var visible = false
    @State var revisible = false
    // MARK: View Properties
    @Environment(\.dismiss) var dismiss
    @State var showImagePicker: Bool = false
    @State var photoItem: PhotosPickerItem?
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    @State var isLoading: Bool = false
    @AppStorage("isRegistrationDone") var isRegisterDone: Bool = false
    // MARK: UserDefaults
    @AppStorage("isGoogleUser") var isGoogleUser: Bool = false
    @AppStorage("isInRegisterMode") var isRegisterView: Bool = false
    @AppStorage("registerStatus") var registerStatus: Bool = false
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("user_profile_url") var profileURL: URL?
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("user_UID") var userUID: String = ""
    @AppStorage("user_profile_pic_data") var profilePicData: Data?
    @AppStorage("user_email") var userEmail: String = ""
    
    var body: some View {
        ZStack(alignment: .topLeading){
            NavigationView {
                if isRegisterDone{
                    MedicalRecordView()
                }else{
                    GeometryReader{_ in
                            VStack(alignment: .leading, spacing: 10){
                                VStack(alignment: .leading,spacing: 0){
                                    Text("Welcome")
                                        .font(.title)
                                        .foregroundColor(Color.black)
                                        .padding(.top,45)
                                    Text("Create your Account")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.black)
                                }
                                .padding(.top,15)
                                VStack{
                                    ZStack{
                                        if let userProfilePicData, let image = UIImage(data: userProfilePicData){
                                            Image(uiImage: image)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                        }else{
                                            Image("NullProfile")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                        }
                                    }
                                    .frame(width: 85, height: 85)
                                    .clipShape(Circle())
                                    .contentShape(Circle())
                                    .onTapGesture {
                                        showImagePicker.toggle()
                                    }
                                    .padding(.top,25)
                                    Text("Select Profile Picture")
                                        .foregroundColor(.biomedPrimary)
                                        .fontWeight(.bold)
                                        .padding(.bottom,25)
                                    TextField("Email", text: self.$email)
                                        .textContentType(.emailAddress)
                                        .border(1, .gray.opacity(0.5))
                                    TextField("Username", text: self.$username)
                                        .textContentType(.emailAddress)
                                        .border(1, .gray.opacity(0.5))
                                    
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
                                    .textContentType(.emailAddress)
                                    .border(1, .gray.opacity(0.5))
                                    // MARK: Login Button
                                    Button(action:{
                                        registerUser()
                                    }){
                                        Text("Sign Up")
                                            .foregroundColor(Color.white)
                                            .fontWeight(.bold)
                                            .padding(.vertical)
                                            .frame(width: UIScreen.main.bounds.width-50)
                                    }
                                    .background(Color.biomedPrimary)
                                    .disableWithOpacity(username == "" || email == "" || pass == "" || userProfilePicData == nil)
                                    .cornerRadius(10)
                                    .padding(.top,15)
                                    .padding(.bottom,15)
                                    
                                    LabelledDivider(label: "or")
                                        .padding(.bottom,15)
                                    Button{
                                        isRegisterView.toggle()
                                        signupVM.signUpWithGoogle()
                                    }label: {
                                        SocialLoginButton(image: "google", text: "Sign in with Google")
                                    }
                                    .padding(.bottom,35)
                                }
                                Spacer()
                                // MARK: Move back to LoginView
                                HStack{
                                    Spacer()
                                    Text("Already have an account?")
                                        .foregroundColor(Color.black)
                                    Button(action: {
                                        dismiss()
                                    }){
                                        Text("Login here")
                                            .foregroundColor(Color.biomedPrimary)
                                            .fontWeight(.bold)
                                    }
                                    Spacer()
                                }
                            }
                            .padding(.horizontal,25)
                        Button(action: {
                            isRegisterView.toggle()
                            dismiss()
                        }){
                            Image(systemName: "chevron.left")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Color.biomedPrimary)
                            Text("Back")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(Color.biomedPrimary)
                        }
                        .padding()
                    }
                }
            }
            
        }
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled(true)
        .navigationBarBackButtonHidden(true)
        .overlay(content:{
            LoadingView(show: $isLoading)
        })
        .photosPicker(isPresented: $showImagePicker, selection: $photoItem)
        .onChange(of: photoItem) { newValue in
            // MARK: Extracting UIImage From PhotoItem
            if let newValue{
                Task{
                    do{
                        guard let imageData = try await newValue.loadTransferable(type: Data.self) else{return}
                        // MARK: UI Must Be Updated on Main Thread
                        await MainActor.run(body: {
                            userProfilePicData = imageData
                        })
                    }catch{}
                }
            }
        }
        // MARK: Set Preferred Color Scheme to Light
        .preferredColorScheme(.light)
        // MARK: Displaying Alert
        .alert(errorMessage, isPresented: $showError, actions: {})
    }
    func registerUser(){
        isLoading = true
        closeKeyboards()
        Task{
            do{
                // Step 1: Create Firebase Account
                try await Auth.auth().createUser(withEmail: email, password: pass)
                // Step 2: Uploading Profile Photo into Firebase
                guard let userUID = Auth.auth().currentUser?.uid else {return}
                guard let imageData = userProfilePicData else {return}
                let storageRef = Storage.storage().reference().child("Profile_Images").child(userUID)
                let _ = try await storageRef.putDataAsync(imageData)
                // Step 3: Downloading Photo URL
                let downloadURL = try await storageRef.downloadURL()
                // Step 4: Creating a User Firestore Object
                let user = User(username: username, userUID: userUID, userEmail: email, userProfileURL: downloadURL)
                // Step 5: Saving User Doc into Firestore Database
                let _ = try Firestore.firestore().collection("Users").document(userUID).setData(from: user, completion: { error in
                    if error == nil{
                        // MARK: Print Saved Succesfully
                        print("Saved Succesfully")
                        userNameStored = username
                        userEmail = email
                        self.userUID = userUID
                        profileURL = downloadURL
                        isLoading = false
                        isRegisterDone.toggle()
                        profilePicData = userProfilePicData
                    }
                })
            }catch{
                // MARK: Deleting Created Account In Case of Failure
                try await Auth.auth().currentUser?.delete()
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
struct SignUp_Previews: PreviewProvider {
    
    static var previews: some View {
        RegisterView()
            .environment(\.colorScheme, .dark)
    }
}
