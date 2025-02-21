//
//  ProfileView.swift
//  bondia
//
//  Created by Priscilla Xavier on 2/13/25.
//
import SwiftUI
import PhotosUI
import Firebase
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore


struct ProfileView: View {
    
    //@State private var profileImage: Image? = Image(systemName: "person.circle.fill")
    
    @State private var profileImage: UIImage? // Store selected profile image
    @State private var selectedProfileItem: PhotosPickerItem?
    @State private var selectedProfileImageData: Data?
    
    @State private var selectedImageItems: [PhotosPickerItem] = []
    @State private var selectedImages: [UIImage] = []
    @State private var imageUploadURLs: [String] = []
    
    @State private var bio: String = "This is your bio."
    @State private var age: String = "25"
    @State private var location: String = "New York, USA"
    @State private var interests: [String] = []
    @State private var allInterests: [String] =  ["Hiking", "Swimming", "Running", "Cycling", "Yoga", "Tennis", "Soccer", "Basketball"]
    
    
    @State private var savingProfile = false // To show loading indicator while saving
    @State private var saveError: String? // To display error messages
    @State private var showError = false
    
    
    @State private var navigateToHome = false
    
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // Profile Picture Section
                profilePictureSection
                
                // Bio Section
                bioSection
                
                // Age Section
                ageSection
                
                // Location Section
                locationSection
                
                // Activity Interests Section
                activityInterestsSection
                
                // Selected Interet Display
                selectedInterestsSection
                
                // Image Upload Section
                imageUploadSection
                
                // Save User Button
                Button(action: saveUserProfile) {
                    Text("Save Profile")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .disabled(savingProfile) // Disable button while saving
                }
                .alert(isPresented: $showError) { // Show error alert
                    Alert(title: Text("Error"), message: Text(saveError ?? "An unknown error occurred."), dismissButton: .default(Text("OK")))
                }}
            
        
            .padding()
           .navigationBarTitle("Profile", displayMode: .inline)
        }
        .onAppear(perform: loadUserProfile)
    }

    
    
    //MARK: - Save Multiple Images to Database
    
    private func uploadMultipleImagesToFirebase() {
        let db = Firestore.firestore()
        var uploadedURLs: [String] = []
        let dispatchGroup = DispatchGroup()
        
        for image in selectedImages {
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                dispatchGroup.enter()
                uploadImageToFirebase(imageData: imageData) { imageURL in
                    if let imageURL = imageURL {
                        uploadedURLs.append(imageURL)
                    }
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            db.collection("users").document("userProfile").updateData(["imageGalleryURLs": uploadedURLs])
        }
    }
    
    // MARK: - Image Upload Section
    private var imageUploadSection: some View {
        VStack(alignment: .leading) {
            Text("Upload Images (max 6 images)")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(selectedImages, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                            .shadow(radius: 5)
                    }
                    
                    if selectedImages.count < 6 {
                        PhotosPicker(selection: $selectedImageItems, matching: .images, photoLibrary: .shared()) {
                            Text("+")
                                .font(.largeTitle)
                                .foregroundColor(.blue)
                                .frame(width: 80, height: 80)
                                .background(Color.gray.opacity(0.1))
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                        }
                        
                        .onChange(of: selectedImageItems) { newItems in
                            Task {
                                for item in newItems {
                                    if let data = try? await item.loadTransferable(type: Data.self),
                                       let uiImage = UIImage(data: data) {
                                        selectedImages.append(uiImage)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    
    // MARK: - Profile Picture Section
    private var profilePictureSection: some View {
        VStack {
            if let imageData = selectedProfileImageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 4))
                    .shadow(radius: 10)
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                    .foregroundColor(.gray)
                
            }
            Spacer()
            
            PhotosPicker(selection: $selectedProfileItem, matching: .images) {
                Text("Change Profile Picture")
                    .foregroundColor(.blue)
            }
            .onChange(of: selectedProfileItem) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        selectedProfileImageData = data
                    }
                }
            }
        }
    }
    
    
    // MARK: - Bio Section
    private var bioSection: some View {
        VStack(alignment: .leading) {
            Text("Bio")
                .font(.headline)
            TextEditor(text: $bio)
                .frame(height: 100)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
        }
    }
    
    // MARK: - Age Section
    private var ageSection: some View {
        VStack(alignment: .leading) {
            Text("Age")
                .font(.headline)
            TextField("Enter your age", text: $age)
                .keyboardType(.numberPad)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
        }
    }
    
    // MARK: - Location Section
    private var locationSection: some View {
        VStack(alignment: .leading) {
            Text("Location")
                .font(.headline)
            TextField("Enter your location", text: $location)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
        }
    }
    
    // MARK: - Activity Interests Section
    private var activityInterestsSection: some View {
        VStack(alignment: .leading) {
            Text("Select Your Interests")
                .font(.headline)
                .padding(.bottom, 5)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                ForEach(allInterests, id: \.self) { interest in
                    Button(action: {
                        if interests.contains(interest) {
                            interests.removeAll { $0 == interest } // Deselect if already selected
                        } else {
                            interests.append(interest) // Select interest
                        }
                    }) {
                        Text(interest)
                            .padding()
                            .frame(minWidth: 80)
                            .background(interests.contains(interest) ? Color.blue : Color.gray.opacity(0.2))
                            .foregroundColor(interests.contains(interest) ? .white : .black)
                            .cornerRadius(10)
                    }
                }
            }
        }
    }
    
    // MARK: - Selected Interests Display Section
    private var selectedInterestsSection: some View {
        VStack(alignment: .leading) {
            Spacer()
            Text("Your Interests")
                .font(.headline)
                .padding(.top, 5)
            
            if interests.isEmpty {
                Text("No interests selected")
                    .foregroundColor(.gray)
            } else {
                ForEach(interests, id: \.self) { interest in
                    Text(interest)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 10)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(8)
                }
            }
            Spacer()
        }
    }
    
    
    //MARK: - Save Data to Firebase
    
    private func uploadDataToFirebase() {
        let db = Firestore.firestore()
        let storage = Storage.storage()
        
        let userProfile: [String: Any] = [
            "bio": bio,
            "age": age,
            "location": location,
            "interests": interests
        ]
        
        db.collection("users").document("userProfile").setData(userProfile) { error in
            if let error = error {
                print("Error saving profile: \(error.localizedDescription)")
            } else {
                print("Profile successfully saved!")
            }
        }
        
        for (index, image) in selectedImages.enumerated() {
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                let storageRef = storage.reference().child("profileImages/image_\(index).jpg")
                storageRef.putData(imageData, metadata: nil) { _, error in
                    if let error = error {
                        print("Error uploading image: \(error.localizedDescription)")
                    } else {
                        print("Image \(index) uploaded successfully!")
                    }
                }
            }
        }
    }
    
    
    // MARK: - Save User Profile
    
    private func saveUserProfile() {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            saveError = "User not logged in."
            showError = true
            return
        }
        
        savingProfile = true
        saveError = nil
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(uid)
        
        var userProfile: [String: Any] = [
            "bio": bio,
            "age": age,
            "location": location,
            "interests": interests
        ]
        
        db.collection("users").document("userProfile").setData(userProfile) { error in
            if let error = error {
                print("Error saving profile: \(error.localizedDescription)")
            } else {
                print("Profile successfully saved!")
                DispatchQueue.main.async {
                    self.navigateToHome = true
                }
            }
            db.collection("users").document("userProfile").getDocument {  (snapshot, error) in
                
                if let profileData = snapshot?.data() {
                    DispatchQueue.main.async {
                        
                    }
                } else if let error = error {
                    print("Error fetching document: \(error.localizedDescription)")
                }
                
            }
            
        }
        
        
        func updateUI(with profileData: [String: Any]) {
            // Update your UI elements here using profileData
            DispatchQueue.main.async {
                self.bio = profileData["bio"] as? String ?? ""
                self.age = profileData["age"] as? String ?? ""
                self.location = profileData["location"] as? String ?? ""
                self.interests = profileData["interests"] as? [String] ?? []
            }
        }
        
        // Upload profile picture asynchronously
        if let imageData = selectedProfileImageData {
            uploadImageToFirebase(imageData: imageData) { url in
                
                if var url = url {
                    userProfile["profileImageURL"] = url  // ✅ Correctly using `userProfile`
                    db.collection("users").document("userProfile").updateData(userProfile)
                } else {
                    self.saveError = "Error uploading profile picture."
                }
            }
        }
        
        
        
        // Upload other images asynchronously
        uploadMultipleImagesToFirebase()
        
        let imageUploadTasks = selectedImages.enumerated().map { (index, image) in
            uploadImageToFirebase(imageData: image.jpegData(compressionQuality: 0.8)!) { url in
                
                if let url = url {
                    self.imageUploadURLs.append(url)
                } else {
                    self.saveError = "Error uploading images."
                }
                
                var updatedProfileData = userProfile
                updatedProfileData["imageGalleryURLs"] = self.imageUploadURLs
                
                if self.selectedImages.count == self.imageUploadURLs.count {
                    self.handleProfileSaveCompletion(success: (self.saveError == nil), profileData: updatedProfileData, userRef: userRef)
                }
            }
        }
    }
    
    
    
    
    
    //MARK: - Handle function to FIrebase
    // Handles profile save completion, combining async operations
    private func handleProfileSaveCompletion(success: Bool, profileData: [String: Any], userRef: DocumentReference) {
        if success {
            userRef.setData(profileData) { error in
                DispatchQueue.main.async {
                    self.savingProfile = false
                    if let error = error {
                        self.saveError = error.localizedDescription
                        self.showError = true
                    } else {
                        print("Profile successfully saved!")
                    }
                }
            }
        } else {
            self.savingProfile = false
            DispatchQueue.main.async {
                self.savingProfile = false
                self.showError = true
            }
        }
    }
    
    // Handles multiple image uploads, and combines the async operations
    private func handleImageUploads(imageUploadTasks: [DispatchWorkItem]) {
        let imageUploadGroup = DispatchGroup()
        for task in imageUploadTasks {
            imageUploadGroup.enter()
            task.notify(queue: .main) { imageUploadGroup.leave() }
            task.perform()
        }
        
        imageUploadGroup.notify(queue: .main) {
            print("All images uploaded.")
        }
    }
    
    
    
    // MARK: - Download User Profile Image
    
    private func downloadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data, let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.profileImage = uiImage
                }
            } else {
                print("Error loading profile image: \(error?.localizedDescription ?? "Unknown error")")
            }
        }.resume()
    }
    
    
    
    
    
    // MARK: - Upload Profile Picture (Modified)
    private func uploadProfilePicture(imageData: Data?, completion: @escaping (String?) -> Void) -> DispatchWorkItem {
        return DispatchWorkItem {
            guard let imageData = imageData else {
                completion(nil)
                return
            }
            uploadImageToFirebase(imageData: imageData) { url in completion(url)
            }
        }
    }
    
    
    
    //MARK: - Upload Image to Database
    
    private func uploadImageToFirebase(imageData: Data, completion: @escaping (String?) -> Void) {
        let storageRef = Storage.storage().reference().child("profileImages/\(UUID().uuidString).jpg")
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                completion(nil)
                return
            }
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error getting download URL: \(error.localizedDescription)")
                    completion(nil)
                } else {
                    completion(url?.absoluteString)
                }
            }
        }
    }
    
    
    
    
    
    
    
    // MARK: - Loads User Profile
    
    private func loadUserProfile() {
        let db = Firestore.firestore()
        db.collection("users").document("userProfile").getDocument {  snapshot, error in
           // guard let self = self else { return } // Ensure `self` exists
            
            if let data = snapshot?.data() {
                DispatchQueue.main.async {
                    self.bio = data["bio"] as? String ?? ""
                    self.age = data["age"] as? String ?? ""
                    self.location = data["location"] as? String ?? ""
                    self.interests = data["interests"] as? [String] ?? []
                }
                
                if let imageUrlString = data["profileImageURL"] as? String, let imageUrl = URL(string: imageUrlString) {
                    DispatchQueue.global(qos: .userInitiated).async {
                        if let imageData = try? Data(contentsOf: imageUrl), let uiImage = UIImage(data: imageData) {
                            DispatchQueue.main.async {
                                self.profileImage = uiImage
                            }
                        }
                    }
                }
                
                if let urls = data["imageGalleryURLs"] as? [String] {
                    DispatchQueue.global(qos: .userInitiated).async {
                        var images: [UIImage] = []
                        for urlString in urls {
                            if let url = URL(string: urlString),
                               let imageData = try? Data(contentsOf: url),
                               let uiImage = UIImage(data: imageData) {
                                images.append(uiImage)
                            }
                        }
                        DispatchQueue.main.async {
                            self.selectedImages = images
                        }
                    }
                }
            } else if let error = error {
                print("Error loading user profile: \(error.localizedDescription)")
            }
        }
    }
    
    
    // MARK: - Load Images
    
    private func loadImages(from urls: [String]) {
        let imageLoadGroup = DispatchGroup()
        var loadedImages: [UIImage] = []
        
        for urlString in urls {
            imageLoadGroup.enter()
            guard let url = URL(string: urlString) else { imageLoadGroup.leave()
                continue
            }
            URLSession.shared.dataTask(with: url) {  data, _, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        loadedImages.append(image)
                        self.selectedImages = loadedImages //Update images on main thread
                    }
                }
                imageLoadGroup.leave()
            }.resume()
        }
        
        imageLoadGroup.notify(queue: .main) {
            // All images are loaded now.
        }
    }
    
    
    
    
    
    struct ProfileView_Previews: PreviewProvider {
        static var previews: some View {
            NavigationView {
                ProfileView()
            }
        }
    }
    
}
