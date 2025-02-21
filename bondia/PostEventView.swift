import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import PhotosUI

struct PostEventView: View {
    @State private var eventTitle = ""
    @State private var eventImage: UIImage?
    @State private var selectedImageItem: PhotosPickerItem?
    @State private var selectedEventImageData: Data?
    
    @State private var eventDate = Date()
    @State private var eventTime = Date()
    @State private var eventLocation = ""
    @State private var eventDescription = ""
    @State private var isTermsAccepted = false
    @State private var eventCost: String = "$50 < 50 people"
    @State private var isGroupChatEnabled = false
    @State private var showConfirmation = false
    
    @State private var allInterests: [String] = ["Hiking", "Swimming", "Running", "Cycling", "Yoga", "Tennis", "Soccer", "Basketball"]
    @State private var eventTags: [String] = []
    @State private var selectedInterest: String = "Hiking"
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    Text("Create Event")
                        .font(.largeTitle)
                        .padding()
                    
                    VStack {
                        if let eventImage = eventImage {
                            Image(uiImage: eventImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                        }
                        
                        PhotosPicker("Upload Event Poster", selection: $selectedImageItem, matching: .images)
                            .onChange(of: selectedImageItem) { newItem in
                                Task {
                                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                                       let uiImage = UIImage(data: data) {
                                        self.eventImage = uiImage
                                        self.selectedEventImageData = data
                                    }
                                }
                            }
                    }
                    
                    TextField("Enter Event Title", text: $eventTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    TextField("Event Location (City, State)", text: $eventLocation)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        
            
                    Text("Event Description")
                        .padding(.top, 20)
                    TextEditor(text: $eventDescription)
                        .border(Color.gray, width: 0.2)
                        .padding()
                        .frame(height: 100)
                    
                    Spacer()
                    
                    VStack{
                        Spacer()
                        Text("Event Date")
                        DatePicker("", selection: $eventDate, displayedComponents: .date)
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .padding()
                    }
                    
                    Spacer()
                    
                    VStack {
                        Text("Event Time")
                        DatePicker("", selection: $eventTime, displayedComponents: .hourAndMinute)
                            .datePickerStyle(WheelDatePickerStyle())
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
                        .pickerStyle(MenuPickerStyle())
                        .padding()
                    }
                    
                    VStack{
                        interestPickerSection
                    }
                    
                    
                    .padding()
                    
                    
                    Toggle("Enable Group Chat for Event", isOn: $isGroupChatEnabled)
                        .padding(.horizontal, 50)
                        .font(.headline)
                    
                    // Event Tags
                    VStack(alignment: .leading) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(eventTags, id: \ .self) { tag in
                                    Text(tag)
                                        .padding(8)
                                        .background(Color.blue.opacity(0.2))
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }
                    
                   
                    .padding()
                        // Terms and Conditions Checkbox
                        HStack {
                            Button(action: {
                                isTermsAccepted.toggle()
                            }) {
                                Image(systemName: isTermsAccepted ? "checkmark.square" : "square")
                                Text("I accept the Terms and Agreements")
                                    .font(.body)
                                    .padding()
                                    .foregroundColor(.black)
                            }
                            
                        }
                       
                }
                    
                    Button("Create Event") {
                        createEvent()
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                    .padding()
                    .alert(isPresented: $showConfirmation) {
                        Alert(title: Text("Event Created"), message: Text("Your event has been successfully created!"), dismissButton: .default(Text("OK")))
                    }
                }
               
            .navigationBarTitle("Post Event", displayMode: .inline)
        }
    }

    private func determineEventTags() {
        let wordsInTitle = eventTitle.lowercased().split(separator: " ")
        eventTags = allInterests.filter { interest in
            wordsInTitle.contains { $0.contains(interest.lowercased()) }
        }
    }

    
    private func createEvent() {
        guard let imageData = selectedEventImageData else {
            print("No image data available")
            return
        }
        
        determineEventTags()
        
        uploadImageToFirebase(imageData: imageData) { imageURL in
            if let imageURL = imageURL {
                saveEventData(imageURL: imageURL)
            }
        }
    }
    
    // MARK: - Interest Picker Section
    private var interestPickerSection: some View {
        VStack(alignment: .leading) {
            Text("Select Event Interest")
                .font(.headline)
                .padding(.bottom, 5)

            Picker("Interest", selection: $selectedInterest) {
                ForEach(allInterests, id: \.self) { interest in
                    Text(interest).tag(interest)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
        .padding()
    }

    
    // MARK: - Upload to Firebase
    
    private func uploadImageToFirebase(imageData: Data, completion: @escaping (String?) -> Void) {
        let storageRef = Storage.storage().reference().child("eventImages/\(UUID().uuidString).jpg")
        storageRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                completion(nil)
            } else {
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
            "tags": eventTags,
            "createdAt": FieldValue.serverTimestamp()
        ]
        
        db.collection("events").addDocument(data: eventData) { error in
            if let error = error {
                print("Error saving event data: \(error.localizedDescription)")
            } else {
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

