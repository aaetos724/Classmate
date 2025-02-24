import SwiftUI

struct RegistrationView: View {
    @StateObject private var courseStore = CourseStore()
    @State private var showingCalendar = false
    @State private var showingAddCourse = false
    
    var body: some View {
        NavigationStack {
            VStack {
                // Progress indicator
                ProgressView("Setup Progress", value: Double(courseStore.courses.count), total: 1)
                    .padding()
                
                if courseStore.courses.isEmpty {
                    // Welcome screen
                    VStack(spacing: 20) {
                        Image(systemName: "calendar")
                            .font(.system(size: 60))
                            .foregroundStyle(.blue)
                        
                        Text("Welcome to Classmate")
                            .font(.title)
                            .bold()
                        
                        Text("Let's set up your weekly schedule")
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                        
                        Button(action: { showingAddCourse = true }) {
                            Text("Add Your First Class")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(.blue)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    .padding()
                } else {
                    // Course list
                    List {
                        ForEach(courseStore.courses) { course in
                            CourseRowView(course: course)
                        }
                        .onDelete { indices in
                            courseStore.deleteCourse(at: indices)
                        }
                    }
                    
                    // Action buttons
                    VStack(spacing: 16) {
                        Button(action: { showingAddCourse = true }) {
                            Text("Add Another Class")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(.blue)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        
                        Button(action: finishSetup) {
                            Text("Complete Setup")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(.green)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Setup")
            .sheet(isPresented: $showingAddCourse) {
                AddCourseView(courseStore: courseStore)
            }
            .fullScreenCover(isPresented: $showingCalendar) {
                CalendarView()
            }
        }
    }
    
    private func finishSetup() {
        UserDefaults.standard.set(true, forKey: "isSetupComplete")
        showingCalendar = true
    }
}

// Preview provider
#Preview {
    RegistrationView()
} 