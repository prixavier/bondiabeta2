import SwiftUI
import FirebaseAuth

struct AccountSettings: View {
    @State private var isSignedIn = true // Track sign-in status
    @StateObject private var viewModel = AuthViewModel()
    
    // Environment variable to handle navigation dismissals
    @Environment(\.presentationMode) var presentationMode
    
    // Use a Binding to handle authentication state for navigating back to ContentView
    @Binding var isAuthenticated: Bool
    @State private var shouldNavigateToContentView = false // Track navigation to ContentView
    
    // State for showing the sign-out confirmation alert
    @State private var showSignOutConfirmation = false
    
    // State for the notification toggle
    @State private var notificationsEnabled: Bool = true // Track notification status
    
    var body: some View {
        VStack {
            Spacer(minLength: 300)
                .navigationTitle("Settings")
            
            // "Go Back to Home" Button
            Button(action: {
                // Dismiss the current view and go back to the Home screen
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Go Back to Home")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            // Show the sign-out button only when the user is signed in
            if isSignedIn {
                Button(action: {
                    // Show sign-out confirmation alert
                    showSignOutConfirmation = true
                }) {
                    Text("Sign Out")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(8)
                        .alert(isPresented: $showSignOutConfirmation) {
                            Alert(
                                title: Text("Confirm Sign Out"),
                                message: Text("Are you sure you want to sign out?"),
                                primaryButton: .destructive(Text("Sign Out")) {
                                    signOut()
                                },
                                secondaryButton: .cancel())
                        }
                }
                .padding()
            }
            
            // Toggle for enabling/disabling notifications
            VStack {
                Text("Enable Notifications")
                    .font(.headline)
                    .padding(.top, 50)
                
                Toggle(isOn: $notificationsEnabled) {
                    Text(notificationsEnabled ? "Notifications Enabled" : "Notifications Disabled")
                        .font(.body)
                        .foregroundColor(notificationsEnabled ? .green : .red)
                }
                .padding()
                .toggleStyle(SwitchToggleStyle(tint: .blue))
            }
            
            NavigationLink(
                destination: ContentView(isAuthenticated: $showSignOutConfirmation),
                isActive: $shouldNavigateToContentView) {
                    EmptyView()
                }
                .offset()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onAppear {
                    // Check if user is authenticated when the view appears
                    isAuthenticated = Auth.auth().currentUser != nil
                }
        }
    }
    
    // Sign-out function
    private func signOut() {
        do {
            try Auth.auth().signOut()  // Firebase sign-out method
            isSignedIn = false // Update sign-in status
            isAuthenticated = false

            // Trigger the navigation to ContentView
            shouldNavigateToContentView = true

        } catch let error {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}

struct AccountSettings_Previews: PreviewProvider {
    static var previews: some View {
        AccountSettings(isAuthenticated: .constant(true))
    }
}

