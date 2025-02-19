import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import ImagePicker

struct PostEventView: View {
    @State private var eventTitle = ""
    @State private var eventImage: Image? = Image(systemName: "photo") // Placeholder image
    @State private var eventImageData: Data? // Store the image data to upload
    @State private var eventDate = Date()
    @State private var eventTime = Date()
    @State private var eventLocation = ""
    @State private var eventDescription = ""
    @State private var isTermsAccepted = false
    @State private var eventCost: String = "$50 < 50 people"
    @State private var isGroupChatEnabled = false
    @State private var showConfirmation = false
    @State private var showImagePicker = false
    
    var body: some View {
        VStack {
            Text("Create Event")
                .font(.largeTitle)
                .padding()
            
            // Event Title Field
            TextField("Event Title", text: $eventTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            // Event Image (with Image Picker)
            VStack {
                eventImage?
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .padding()
                Text("Event Image (Placeholder)")
                    .foregroundColor(.gray)
                
                Button("Choose Image") {
                    showImagePicker = true
                }
                .padding()
                .foregroundColor(.blue)
            }
            
            // Event Date and Time Picker
            HStack {
                VStack {
                    Text("Event Date")
                    DatePicker("Select Date", selection: $eventDate, displayedComponents: .date)
                        .datePickerStyle(WheelDatePickerStyle())
                        .padding()
                }
                VStack {
                    Text("Event Time")
                    DatePicker("Select Time", selection: $eventTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(WheelDatePickerStyle())
                        .padding()
                }
            }
            
            // Event Location Field
            TextField("Event Location", text: $eventLocation)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            // Event Description Field
            TextEditor(text: $eventDescription)
                .border(Color.gray, width: 1)
                .padding()
                .frame(height: 100)
            
            // Terms and Conditions Checkbox
            HStack {
                Button(action: {
                    isTermsAccepted.toggle()
                }) {
                    Image(systemName: isTermsAccepted ? "checkmark.square" : "square")
                    Text("I accept the Terms and Agreements")
                        .font(.body)
                }
                .padding()
            }
            
            // Event Cost Selection
            VStack {
                Text("Event Cost per Attendee")
                    .font(.headline)
                    .padding(.top, 20)
                
                Picker("Select Cost", selection: $eventCost) {
                    Text("$50 < 50 people").tag("$50 < 50 people")
                    Text("$100 < 100 people").tag("$100 < 100 people")
                    Text("$500 < 500 people").tag("$500 < 500 people")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
            }
            
            // Group Chat Toggle
            Toggle(isOn: $isGroupChatEnabled) {
                Text("Enable Groupchat for Event")
                    .font(.body)
            }
            .padding()
            
            // Create Event Button
            Button(action: {
                createEvent()
            }) {
                Text("Create Event")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding()
            
            // Confirmation Alert
            .alert(isPresented: $showConfirmation) {
                Alert(title: Text("Event Created"), message: Text("Your event has been successfully created!"), dismissButton: .default(Text("OK")))
            }
            
            Spacer()
        }
        .padding()
        .imagePicker(isPresented: $showImagePicker, image: $eventImageData, onImagePicked: { _ in })
    }
    
    private func createEvent() {
        // Validate all required fields
        guard !eventTitle.isEmpty,
              !eventLocation.isEmpty,
              !eventDescription.isEmpty,
              isTermsAccepted,
              let imageData = eventImageData else {
                  // Show an error or return
                  return
              }
        
        // Upload image to Firebase Storage
        uploadImage(imageData) { imageURL in
            if let imageURL = imageURL {
                // Save the event data to Firestore
                saveEventData(imageURL: imageURL)
            }
        }
    }
    
    private func uploadImage(_ imageData: Data, completion: @escaping (String?) -> Void) {
        let storageRef = Storage.storage().reference().child("event_images/\(UUID().uuidString).jpg")
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error getting image URL: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                completion(url?.absoluteString)
            }
        }
    }
    
    private func saveEventData(imageURL: String) {
        let db = Firestore.firestore()
        let eventData: [String: Any] = [
            "title": eventTitle,
            "imageURL": imageURL,
            "date": eventDate,
            "time": eventTime,
            "location": eventLocation,
            "description": eventDescription,
            "cost": eventCost,
            "groupChatEnabled": isGroupChatEnabled,
            "createdAt": FieldValue.serverTimestamp()
        ]
        
        db.collection("events").addDocument(data: eventData) { error in
            if let error = error {
                print("Error saving event data: \(error.localizedDescription)")
            } else {
                // Show confirmation message
                showConfirmation = true
            }
        }
    }
}

struct PostEventView_Previews: PreviewProvider {
    static var previews: some View {
        PostEventView()
    }
}

