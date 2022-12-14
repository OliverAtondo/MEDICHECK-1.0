//
//  LoginViewModel.swift
//  MedCheck
//
//  Created by Ivan Lorenzana Belli on 05/12/22.
//

import SwiftUI
import Firebase
import GoogleSignIn

class SignUpViewModel: ObservableObject{
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("registerStatus") var registerStatus: Bool = false
    @AppStorage("user_profile_url") var profileURL: URL?
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("user_UID") var userUID: String = ""
    @AppStorage("isInRegisterMode") var isRegisterView: Bool = false
    @AppStorage("isGoogleUser") var isGoogleUser: Bool = false
    @AppStorage("googleProfilePic") var photoURL: String = ""
    @AppStorage("user_email") var userEmail: String = ""
    @AppStorage("isRegistrationDone") var isRegisterDone: Bool = false
    // MARK: Error Properties
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    func signUpWithGoogle(){
        guard let clientID = FirebaseApp.app()?.options.clientID else{return}
        
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: ApplicationUtility.rootViewController){
            [self] user, err in
            
            if let error = err{
                print(error.localizedDescription)
                return
            }
            
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else {return}
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
            Auth.auth().signIn(with: credential){ result, error in
                if let err = error{
                    print(err.localizedDescription)
                    return
                }
                guard let user = result?.user else {return}
                self.isGoogleUser = true
                self.photoURL = "\(user.photoURL)"
                print("\(user.photoURL)")
                print("\(self.isGoogleUser)")
                print("Log status \(self.logStatus)")
                self.userUID = user.uid
                self.userNameStored = user.displayName ?? "Not Defined"
                self.userEmail = user.email ?? "Not defined"
                if self.isRegisterView{
                    self.isRegisterDone.toggle()
                }else{
                    self.logStatus.toggle()
                }
                
            }
        }
    }
}
