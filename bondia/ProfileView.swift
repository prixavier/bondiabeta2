//
//  ProfileView.swift
//  bondia
//
//  Created by Priscilla Xavier on 2/13/25.
//
import SwiftUI

struct ProfileView: View {
    @State private var profileImage: Image? = Image(systemName: "person.circle.fill")
    @State private var showImagePicker: Bool = false
    @State private var selectedImages: [UIImage] = []
    @State private var bio: String = "This is your bio."
    @State private var age: String = "25"
    @State private var location: String = "New York, USA"
    @State private var interests: [String] = ["Hiking", "Swimming", "Running", "Cycling"]
    
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
                
                // Image Upload Section
                imageUploadSection
            }
            .padding()
            .navigationBarTitle("Profile", displayMode: .inline)
        }
    }
    
    // MARK: - Profile Picture Section
    private var profilePictureSection: some View {
        VStack {
            profileImage?
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 150)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.gray, lineWidth: 4))
                .shadow(radius: 10)
                .padding(.bottom, 20)
            
            Button(action: {
                showImagePicker = true
            }) {
                Text("Change Profile Picture")
                    .foregroundColor(.blue)
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
            Text("Activity Interests")
                .font(.headline)
                .padding(.bottom, 5)
            
            ForEach(interests, id: \.self) { interest in
                Text(interest)
                    .padding(.vertical, 4)
                    .padding(.leading, 10)
            }
        }
        .padding(.leading, 10)
    }
    
    // MARK: - Image Upload Section
    private var imageUploadSection: some View {
        VStack(alignment: .leading) {
            Text("Upload Images")
                .font(.headline)
            
            HStack {
                ForEach(selectedImages.prefix(6), id: \.self) { image in
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                        .shadow(radius: 5)
                }
                
                if selectedImages.count < 6 {
                    Button(action: {
                        showImagePicker = true
                    }) {
                        Text("+")
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                            .frame(width: 80, height: 80)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                    }
                }
            }
        }
    }
    
    // MARK: - Image Picker
    private var imagePicker: some View {
        ImagePicker(isPresented: $showImagePicker, selectedImages: $selectedImages)
    }
}

struct ImagePicker: View {
    @Binding var isPresented: Bool
    @Binding var selectedImages: [UIImage]
    
    var body: some View {
        VStack {
            if isPresented {
                // This is a placeholder for image picker.
                // Implement your image picker functionality here (e.g., using UIImagePickerController)
                Text("Image Picker Placeholder")
                    .font(.title)
                    .foregroundColor(.blue)
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView()
        }
    }
}
