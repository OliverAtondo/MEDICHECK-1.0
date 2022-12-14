//
//  SocialLoginButton.swift
//  MedCheck
//
//  Created by Ivan Lorenzana Belli on 05/12/22.
//

import SwiftUI

struct SocialLoginButton: View {
    var image: String
    var text: String
    var body: some View {
        HStack(alignment: .center){
            Image(image)
                .padding(.horizontal)
            Spacer()
            Text(text)
                .font(.title3)
                .foregroundColor(.black)
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(50.0)
        .overlay(RoundedRectangle(cornerRadius: 50).stroke(Color.black,lineWidth: 1))
    }
}

struct SocialLoginButton_Previews: PreviewProvider {
    static var previews: some View {
        SocialLoginButton(image: "google", text: "Hola")
    }
}
