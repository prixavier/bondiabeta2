//
//  bondiaApp.swift
//  bondia
//
//  Created by Priscilla Xavier on 2/12/25.
//



import SwiftUI
import FirebaseCore


@main

struct bondia: App {
    
    @State private var isAuthenticated = false
    init() {
        FirebaseApp.configure() // Ensure Firebase is configured here
    }

    var body: some Scene {
        WindowGroup {
            ContentView(isAuthenticated: $isAuthenticated)
        }
    }
}
