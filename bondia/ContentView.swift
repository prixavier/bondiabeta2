//
//  ContentView.swift
//  bondia
//
//  Created by Priscilla Xavier on 2/12/25.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct ContentView: View {
    @Binding var isAuthenticated: Bool
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String? = nil
    @State private var navigateToHome = false
    // Trigger navigation to home
    @State private var navigateToLanding = false
    // State for showing the sign-out confirmation alert
    @State private var showSignOutConfirmation = false
    
    var body: some View {
        
        GeometryReader{ geometry in
            
            NavigationStack {
                VStack {
                    
                    Image(.bondialogo)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .aspectRatio(contentMode: .fill)
                    
                    
                    Text("Welcome to Bondia!")
                        .font(.title2)
                        .frame(maxHeight: 30, alignment: .top)
                        .padding()
                    
                    if isAuthenticated {
                        
                        Button("Go to Home Screen") {
                            navigateToHome = true // Trigger navigation
                            
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .navigationDestination(isPresented: $navigateToHome) {
                            HomeView(isAuthenticated: $isAuthenticated) // Navigate to HomeScreen
                            
                        }
                        
                        // Sign Out button to log out the user
                        Button("Sign Out") { signOut()
                            
                        }
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .alert(isPresented: $showSignOutConfirmation) {
                            Alert(
                                title: Text("Confirm Sign Out"),
                                message: Text("Are you sure you want to sign out?"),
                                primaryButton: .destructive(Text("Sign Out")) {
                                    signOut()
                                },
                                secondaryButton: .cancel()
                            )}
                        
                        
                        
                    } else {
                        
                        // Sign-up form
                        
                        TextField("Email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: geometry.size.width * 0.8)
                        
                        SecureField("Password", text: $password)
                        
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: geometry.size.width * 0.8)
                        
                        Text("Forgot Password? Reset Now")
                            .foregroundColor(.darkbluelogo)
                            .padding(.top, 1)
                            .frame(width: geometry.size.width * 0.8)
                        
                        Button(action: signIn) {
                            Text("Sign In")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                        .padding()
                        
                        NavigationLink(destination: SignUpView()) {
                            Text("Don't have an account? Sign Up")
                                .foregroundColor(.blue)
                                .frame(width: geometry.size.width * 0.8)
                            
                        }
                        
                        
                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .padding()
                            
                        }
                        
                    }
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background {
                    Color.lightbluelogo
                        .ignoresSafeArea()
                }
                .edgesIgnoringSafeArea(.bottom)
                .onAppear {
                    // Check if user is authenticated when the view appears
                    isAuthenticated = Auth.auth().currentUser != nil
                    
                }
            }
        }
    }
    
    private func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else {
                self.isAuthenticated = true // Successfully signed in
                // Once authenticated, show the "Go to Home Screen" button
            }
        }
    }
    
    private func signOut() {
        do {
            try Auth.auth().signOut()  // Firebase sign-out method
            isAuthenticated = false  // Reset authentication status
            navigateToLanding = true
        } catch let error {
            self.errorMessage = error.localizedDescription
        }
    }
    
    
}
        struct ContentView_Previews: PreviewProvider {
            @State static private var isAuthenticated = false
            
            static var previews: some View {
                ContentView(isAuthenticated: $isAuthenticated)
            }
        }


