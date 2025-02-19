//
//  LoginView.swift
//  bondia
//
//  Created by Priscilla Xavier on 2/12/25.
//

//
//  LoginView.swift
//  bondia
//
//  Created by Priscilla Xavier on 2/11/25.
//

import SwiftUI
import FirebaseAuth

struct LoginInView: View {
    @StateObject private var viewModel = AuthViewModel()  // Use @StateObject for ViewModel initialization
    @State private var navigateToHome = false  // Track navigation state
    
    var body: some View {
        GeometryReader{ geometry in
            VStack {
                Image(.bondialogo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .aspectRatio(contentMode: .fill)
                
                Text("Sign In")
                    .padding()
                    .font(.largeTitle)
                    .frame(width: 300)
                
                
                // Email TextField binding to viewModel.email
                TextField("Email", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: geometry.size.width * 0.8)
                
                
                // Password SecureField binding to viewModel.password
                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: geometry.size.width * 0.8)
                
                // Sign In Button
                Button(action: {
                    viewModel.signIn()  // Call the signIn method from AuthViewModel
                }) {
                    Text("Sign In")
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                    
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                
                
                // Error message if any
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                // NavigationLink to HomeView if authenticated
                NavigationLink(destination: HomeView(isAuthenticated: .constant(true)), isActive: $navigateToHome) {
                    EmptyView()  // Empty View as the actual navigation is triggered by the `isActive` state
                }
            }
            .onChange(of: viewModel.isAuthenticated) { isAuthenticated in
                if isAuthenticated {
                    navigateToHome = true // Trigger navigation when authenticated
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
    struct LoginInView_Previews: PreviewProvider {
        static var previews: some View {
            LoginInView()
        }
    }
}
