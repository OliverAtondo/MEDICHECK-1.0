//
//  SplashScreenView.swift
//  MedCheck
//
//  Created by Ivan Lorenzana Belli on 29/11/22.
//

import SwiftUI

struct SplashScreenView: View {
    @AppStorage("log_status") var logStatus: Bool = false
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        if isActive{
            // MARK: Redirecting User Based on Log Status
            if logStatus{
                MainScreenView()
            }else{
                LoginView()
            }
        } else {
            ZStack{
                Color("Background")
                    .ignoresSafeArea()
                VStack{
                    Spacer()
                    VStack{
                        Spacer()
                        Image("LogoModificado")
                            .resizable()
                            .scaledToFit()
                        Spacer()
                        Text("Medcheck")
                            .foregroundColor(Color.biomedPrimary)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                    }
                    .scaleEffect(size)
                    .opacity(opacity)
                    .onAppear{
                        withAnimation(.easeIn(duration: 1.5)){
                            self.size = 0.9
                            self.opacity = 1.0
                        }
                    }
                }
                .onAppear{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.4){
                        withAnimation {
                            self.isActive = true
                        }
                    }
                }
            }
            .preferredColorScheme(.light)
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SplashScreenView()
            
            SplashScreenView()
                .environment(\.colorScheme, .dark)
        }
    }
}
