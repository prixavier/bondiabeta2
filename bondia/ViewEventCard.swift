//
//  EventCardView.swift
//  bondia
//
//  Created by Priscilla Xavier on 2/13/25.
//

import SwiftUI

//struct ViewEventCard: View {
//    // Sample event data
//    var eventImage: String = "photo.fill"  // Placeholder image
//    var eventTitle: String = "Sample Event"
//    var eventDate: String = "March 25, 2025"
//    var eventDescription: String = "This is a detailed description of the event. It talks about the event details, what to expect, and how to participate."
//
//    var body: some View {
//        ScrollView {
//            VStack(spacing: 20) {
//                // Event Placeholder Image
//                Image(systemName: eventImage)  // Placeholder image (use actual event image here)
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: UIScreen.main.bounds.width - 40, height: 200)
//                    .clipped()
//                    .cornerRadius(12)
//                    .padding(.top)
//
//                // Event Title
//                Text(eventTitle)
//                    .font(.largeTitle)
//                    .fontWeight(.bold)
//                    .padding(.horizontal)
//
//                // Event Date
//                Text(eventDate)
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//                    .padding([.leading, .trailing])
//
//                // Event Description
//                Text(eventDescription)
//                    .font(.body)
//                    .foregroundColor(.black)
//                    .padding([.leading, .trailing])
//                
//                // "Join Group Chat" Button
//                NavigationLink(destination: GroupChatView()) {
//                    Text("Join Group Chat")
//                        .foregroundColor(.white)
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        .background(Color.blue)
//                        .cornerRadius(8)
//                }
//                .padding([.leading, .trailing])
//                
//                Spacer()
//            }
//        }
//        .navigationTitle("Event Details")
//        .navigationBarTitleDisplayMode(.inline)
//    }
//}
//
//struct GroupChatView: View {
//    var body: some View {
//        VStack {
//            Text("Group Chat")
//                .font(.largeTitle)
//                .padding()
//            
//            // Placeholder content for the group chat view
//            Text("This is where the group chat will appear.")
//                .padding()
//            
//            Spacer()
//        }
//        .navigationTitle("Group Chat")
//    }
//}
//
//struct ViewEventCard_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            ViewEventCard()
//        }
//    }
//}
//
