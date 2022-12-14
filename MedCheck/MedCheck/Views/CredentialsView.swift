//
//  CredentialsView.swift
//  MedCheck
//
//  Created by Ivan Lorenzana Belli on 07/12/22.
//

import SwiftUI

struct CredentialsView: View {
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("is_google_user") var isGoogleUser: Bool = false
    @State var show = false
    
    var body: some View {
        ZStack{
            Color("Background")
                .ignoresSafeArea()
//            if logStatus{
//                MainScreenView()
//            }else{
//                LoginView()
//            }
            MedicalRecordView()
        }
    }
}

struct CredentialsView_Previews: PreviewProvider {
    static var previews: some View {
        CredentialsView()
    }
}
