//
//  ContentView.swift
//  Classmate2
//
//  Created by Aaetos on 19/02/25.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isSetupComplete") private var isSetupComplete = false
    
    var body: some View {
        if isSetupComplete {
            CalendarView()
        } else {
            RegistrationView()
        }
    }
}

#Preview {
    ContentView()
}
