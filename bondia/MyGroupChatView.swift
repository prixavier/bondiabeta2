//
//  GroupChatView.swift
//  bondia
//
//  Created by Priscilla Xavier on 2/13/25.
//

import SwiftUI

// Group Model to represent each group the user joined
struct Group: Identifiable {
    var id: UUID = UUID()
    var name: String
    var memberCount: Int
    var lastMessage: String
}

struct MyGroupChatView: View {
    // Sample data for groups the user has joined
    @State private var groups: [Group] = [
        Group(name: "Adventure Seekers", memberCount: 12, lastMessage: "See you at the hiking spot!"),
        Group(name: "Tech Enthusiasts", memberCount: 8, lastMessage: "Who's up for a coding challenge?"),
        Group(name: "Book Club", memberCount: 5, lastMessage: "Next meeting is on Sunday!"),
        Group(name: "Cooking Lovers", memberCount: 10, lastMessage: "We need a new recipe for the potluck!")
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                
                // List of joined groups
                List(groups) { group in
                    NavigationLink(destination: ChatView(group: group)) {
                        GroupRow(group: group)
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("My Groups")
            .padding()
            
        }
    }
}

struct GroupRow: View {
    var group: Group
    
    var body: some View {
        HStack {
            // You could replace this with a custom image for each group
            Image(systemName: "bubble.left.fill")
                .font(.title)
                .foregroundColor(.blue)
                .padding(.trailing)
            
            VStack(alignment: .leading) {
                Text(group.name)
                    .font(.headline)
                Text("\(group.memberCount) members")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(group.lastMessage)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
    }
}

// ChatView for each group that the user taps
struct ChatView: View {
    var group: Group
    
    var body: some View {
        VStack {
            Text("Welcome to \(group.name)!")
                .font(.title)
                .padding()
                .frame(alignment: .center)
            
            Text("This is the group chat for \(group.name).")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Spacer()
            
            // Add Chat content here. For now, a simple placeholder.
            Text("Chat messages will be displayed here.")
                .padding()
            
            Spacer()
            
            // Add a text field to send messages (optional)
            HStack {
                TextField("Type a message...", text: .constant(""))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    // Handle sending messages
                }) {
                    Text("Send")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
            }
        }
        .navigationTitle(group.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MyGroupChatView_Previews: PreviewProvider {
    static var previews: some View {
        MyGroupChatView()
    }
}
