//
//  LoginView.swift
//  ABMA
//
//  Created by Nate Condell on 1/18/24.
//  Copyright © 2024 Nathan Condell. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    
    var isLoggedIn: Bool
    
    @State private var showLogin = false
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isWorking = false
    @State private var error: String? = nil
    
    private var isShowingError: Binding<Bool> {
            Binding {
                error != nil
            } set: { _ in
                error = nil
            }
        }
    
    var body: some View {
        HStack {
            if isWorking {
                Text("Logging in")
                ProgressView()
            } else {
                Text("Log in to save notes online")
                Button("Log In") {
                    showLogin.toggle()
                }
            }
        }
        .alert("Log In", isPresented: $showLogin) {
            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
            SecureField("Password", text: $password)
            Button(role: .cancel) {
                print("Cancelled")
            } label: {
                Text("Cancel")
            }
            Button("New User") {
                isWorking.toggle()
                DbManager.sharedInstance.registerUser(email: email, password: password) { errorString in
                    isWorking.toggle()
                    error = errorString
                }
            }
            Button("Existing User") {
                isWorking.toggle()
                DbManager.sharedInstance.login(email: email, password: password) { errorString in
                    isWorking.toggle()
                    error = errorString
                }
            }
        }
        .alert("Error logging in", isPresented: isShowingError, actions: {
            Button("OK") {
                error = nil
            }
        }) {
            Text(error ?? "Unknown Error")
        }
    }
}

//#Preview {
//    LoginView()
//}
