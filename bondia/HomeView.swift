import SwiftUI

struct HomeView: View {
    @State private var searchText = ""
    @State private var selectedTab: Int = 0
    @State private var showResults = false
    @Binding var isAuthenticated: Bool
    @Environment(\.presentationMode) var presentationMode
    
    let activities = ["Hiking", "Running", "Swimming", "Football"]
    
    var filteredActivities: [String] {
        if searchText.isEmpty {
            return activities
        } else {
            return activities.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
    }

    var body: some View {
        ZStack {
            // Main Content
            NavigationView {
                VStack {
                    // Header Section
                    headerSection
                    
                    // Search Bar Section
                    searchBarSection
                    
                    // Show Results Button Section
                    showResultsSection
                    
                    // Scrollable Content Section (Event Cards)
                    eventCardsSection
                    
                    // Bottom Navigation Bar only visible if authenticated



                    if isAuthenticated {
                        bottomNavigationBar
                    }
                }
                .navigationBarTitle("Home", displayMode: .inline)
                .navigationBarItems(trailing: NavigationLink(destination: AccountSettings(isAuthenticated: .constant(true))) {
                    Image(systemName: "gear")
                        .font(.title)
                })
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        Text("Featured Events")
            .font(.title)
            .fontWeight(.bold)
            .padding()
    }
    
    // MARK: - Search Bar Section
    private var searchBarSection: some View {
        HStack {
            TextField("Search for activities", text: $searchText)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding([.leading, .trailing])
            
            // Search Button
            Button(action: {
                showResults = true // Show results when the search button is clicked
            }) {
                Text("Search")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding(.trailing)
    }
    
    // MARK: - Show Results Button Section
    private var showResultsSection: some View {
        VStack {
            if showResults {
                if filteredActivities.isEmpty {
                    // If there are no results after searching
                    Text("No results found")
                        .foregroundColor(.red)
                        .padding()
                } else {
                    // List of activities that match search
                    List(filteredActivities, id: \.self) { activity in
                        Text(activity)
                            .padding()
                    }
                }
            }
        }
    }
    // MARK: - Scrollable Content Section (Event Cards)
    private var eventCardsSection: some View {
        ScrollView {
            VStack(spacing: 15) {
                // Placeholder Cards
                ForEach(0..<5, id: \.self) { index in
                    NavigationLink(destination: ViewEventCard(
                        eventImage: "photo.fill", // Example placeholder image
                        eventTitle: "Event Title \(index)",
                        eventDate: "March 25, 2025",
                        eventDescription: "This is a detailed description of the event.",
                        memberCount: 10, // Example member count
                        lastMessage: "Last message here" // Example last message
                    )) {
                        VStack {
                            Image(systemName: "photo.fill") // Placeholder Image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 75, height: 65)
                                .clipped()
                                .cornerRadius(12)
                                .padding()

                            Text("Event Title \(index)")
                                .font(.headline)
                                .padding(.bottom, 5)

                            Text("Event description goes here. This can be a detailed description of the event.")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding([.leading, .trailing])
                        }
                        .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray, lineWidth: 1).shadow(radius: 5))
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.bottom, 50)
        }
    }
    
    // MARK: - Bottom Navigation Bar
    private var bottomNavigationBar: some View {
        HStack {
            NavigationLink(destination: HomeView(isAuthenticated: $isAuthenticated)) {
                Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                    .font(.title)
                    .padding()
                    .foregroundColor(selectedTab == 0 ? .blue : .gray)
            }
            Spacer()
            NavigationLink(destination: CalendarView()) {
                Image(systemName: selectedTab == 1 ? "calendar.circle.fill" : "calendar")
                    .font(.title)
                    .padding()
                    .foregroundColor(selectedTab == 1 ? .blue : .gray)
            }
            Spacer()
            NavigationLink(destination: ProfileView()) {
                Image(systemName: selectedTab == 2 ? "person.circle.fill" : "person.circle")
                    .font(.title)
                    .padding()
                    .foregroundColor(selectedTab == 2 ? .blue : .gray)
            }
            Spacer()
            NavigationLink(destination: MyGroupChatView()) {
                Image(systemName: selectedTab == 3 ? "bubble.left.circle.fill" : "bubble.left.circle")
                    .font(.title)
                    .padding()
                    .foregroundColor(selectedTab == 3 ? .blue : .gray)
            }
        }
        .frame(height: 60)
        .background(Color.white)
        .shadow(radius: 10)
    }
}

// MARK: - Event Card
struct ViewEventCard: View {
    var eventImage: String = "photo.fill"  // Placeholder image
    var eventTitle: String = "Sample Event"
    var eventDate: String = "March 25, 2025"
    var eventDescription: String = "This is a detailed description of the event. It talks about the event details, what to expect, and how to participate."
    var memberCount: Int
    var lastMessage: String

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Event Placeholder Image
                Image(systemName: eventImage)  // Placeholder image (use actual event image here)
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width - 40, height: 200)
                    .clipped()
                    .cornerRadius(12)
                    .padding(.top)
                    .foregroundColor(.darkbluelogo)

                // Event Title
                Text(eventTitle)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.horizontal)

                // Event Date
                Text(eventDate)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding([.leading, .trailing])

                // Event Description
                Text(eventDescription)
                    .font(.body)
                    .foregroundColor(.black)
                    .padding([.leading, .trailing])
                
                Spacer(minLength: 30)
                
                // "Join Group Chat" Button
                NavigationLink(destination: JoinGroupChatView()) {
                    Text("Join Group Chat")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding([.leading, .trailing])
                
                Spacer()
            }
        }
        .navigationTitle("Event Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct JoinGroupChatView: View {
    var body: some View {
        VStack {
            Spacer()
            // Using the 'sparkles' icon from SF Symbols as a confetti representation
            Image(systemName: "sparkles")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.yellow)
                        
            Text("Congratulations!")
                .font(.title)
                .fontWeight(.bold)

            // Placeholder content for the group chat view
            Text("Your invite has been sent. We will notify you when it has been accepted.")
                .frame(width: UIScreen.main.bounds.width - 40, height: 200, alignment: .center)
            
            Spacer()
        }
        .navigationTitle("Group Chat")
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(isAuthenticated: .constant(true))
    }
}
