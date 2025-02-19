//
//  SignUp.swift
//  bondia
//
//  Created by Priscilla Xavier on 2/12/25.
//

import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var navigateToHome = false
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                VStack {
                    Image(.bondialogo)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .aspectRatio(contentMode: .fill)
                    
                    Text("Sign Up")
                        .font(.largeTitle)
                        .padding()
                    
                    TextField("Email", text: $viewModel.email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: geometry.size.width * 0.8)
                    
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: geometry.size.width * 0.8)
                    
                    Button(action: {
                        viewModel.signUp()
                    }) {
                        Text("Sign Up")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    .onChange(of: viewModel.isAuthenticated) { isAuthenticated in
                        if isAuthenticated {
                            navigateToHome = true // Trigger navigation when authenticated
                        }
                    }
                    .padding()
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    }
                    
                    NavigationLink(destination: LoginInView(), isActive: $navigateToHome) {
                        EmptyView()
                    }
                    
                    NavigationLink(destination: LoginInView()) {
                        Text("Already have an account? Log in")
                            .foregroundColor(.blue)
                    }
                }
                .padding(.bottom, 50)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background {
                    Color.lightbluelogo
                        .ignoresSafeArea()
                }
            }
        }
    }

    func signUp(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Sign Up Failed: \(error.localizedDescription)")
                return
            }
            
            // User signed up successfully
            print("User signed up: \(result?.user.email ?? "")")
        }
    }

}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()  // Preview the SignUpView
    }
}
