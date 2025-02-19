import Firebase
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isAuthenticated: Bool = false
    @Published var errorMessage: String? = nil
    
    private var db = Firestore.firestore() // Make sure Firestore is imported and initialized
    
    func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authDataResult, error in
            if let error = error {
                // Handle the error
                self?.errorMessage = error.localizedDescription
                self?.isAuthenticated = false
                return
            }
            
            // Successfully created user, now store additional data in Firestore
            guard let user = authDataResult?.user else { return }
            
            // Create user data to store in Firestore
            let userData: [String: Any] = [
                "email": user.email ?? "",
                "uid": user.uid,
                "createdAt": Timestamp(),
                "username": "New User"  // Placeholder username, can be updated later
            ]
            
            // Save user data to Firestore under 'users' collection
            self?.db.collection("users").document(user.uid).setData(userData) { error in
                if let error = error {
                    self?.errorMessage = "Failed to save user data: \(error.localizedDescription)"
                } else {
                    self?.isAuthenticated = true // Mark as authenticated
                }
            }
        }
    }
    func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authDataResult, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                self?.isAuthenticated = false
            } else {
                self?.isAuthenticated = true
            }
            
        }
    }
}
