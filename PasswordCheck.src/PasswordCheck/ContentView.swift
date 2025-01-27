//
//  ContentView.swift
//  PasswordCheck
//
//  Created by pancake on 9/7/24.
//

import SwiftUI

// let correctPassword = "^ipassword123"
struct ContentView: View {
    @State private var password: String = ""
    @State private var isAuthenticated: Bool = false
    @State private var showingAlert: Bool = false
    
    
    var body: some View {
        VStack {
            Text("Enter Password")
                .font(.largeTitle)
                .padding()
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                if checkPassword(self.password) {
                    self.isAuthenticated = true
                    self.showingAlert = true
                } else {
                    self.isAuthenticated = false
                    self.showingAlert = true
                }
            }) {
                Text("Submit")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(isAuthenticated ? "Success" : "Error"), message: Text(isAuthenticated ? "Password is correct!" : "Incorrect password."), dismissButton: .default(Text("OK")))
            }
        }
        .padding()
    }
}
