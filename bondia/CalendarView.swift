//
//  CalendarView.swift
//  bondia
//
//  Created by Priscilla Xavier on 2/13/25.
//
import SwiftUI

struct CalendarView: View {
    @State private var selectedDate: Date? = nil
    @State private var events: [Date: String] = [:] // Store events by date
    @State private var newEventText: String = ""
    
    var body: some View {
        VStack {
            // Calendar Header
            CalendarHeader()
            
            // Calendar Grid
            CalendarGrid(selectedDate: $selectedDate, events: $events)
            
            // If a date is selected, show event entry section
            if let selectedDate = selectedDate {
                VStack {
                    Text("Add Event for \(formattedDate(date: selectedDate))")
                        .font(.headline)
                        .padding()
                    
                    TextField("Enter event details", text: $newEventText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button(action: {
                        addEvent(for: selectedDate)
                    }) {
                        Text("Add Event")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    .padding()
                }
                .padding()
            }
            
            Spacer()
        }
        .navigationTitle("Calendar")
    }
    
    // Add event for the selected date
    func addEvent(for date: Date) {
        guard !newEventText.isEmpty else { return }
        events[date] = newEventText
        newEventText = "" // Reset text field after adding
    }
    
    // Format the date to a string
    func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

// Calendar Header
struct CalendarHeader: View {
    var body: some View {
        HStack {
            Text("September 2025") // You can dynamically calculate the current month here
                .font(.title)
                .fontWeight(.bold)
            Spacer()
        }
        .padding()
    }
}

// Calendar Grid
struct CalendarGrid: View {
    @Binding var selectedDate: Date?
    @Binding var events: [Date: String]
    
    let daysInMonth = 30 // Just an example; dynamically calculate based on the current month.
    let columns = 7 // Days in a week
    
    var body: some View {
        let gridItems = Array(repeating: GridItem(.flexible(), spacing: 10), count: columns)
        
        LazyVGrid(columns: gridItems, spacing: 10) {
            ForEach(1...daysInMonth, id: \.self) { day in
                let date = getDate(for: day)
                
                VStack {
                    Text("\(day)")
                        .font(.headline)
                        .frame(width: 40, height: 40)
                        .background(self.selectedDate == date ? Color.blue : Color.clear)
                        .cornerRadius(8)
                        .foregroundColor(self.selectedDate == date ? .white : .black)
                        .onTapGesture {
                            selectedDate = date
                        }
                    
                    // Display event text if there's an event for the selected date
                    if let event = events[date] {
                        Text(event)
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding([.top, .bottom], 4)
                    }
                }
            }
        }
        .padding()
    }
    
    // Get Date object for each day
    func getDate(for day: Int) -> Date {
        let calendar = Calendar.current
        let currentMonth = calendar.dateComponents([.year, .month], from: Date())
        let dateComponents = DateComponents(year: currentMonth.year, month: currentMonth.month, day: day)
        return calendar.date(from: dateComponents) ?? Date()
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CalendarView()
        }
    }
}

