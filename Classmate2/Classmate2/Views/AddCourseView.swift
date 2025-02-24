import SwiftUI

struct AddCourseView: View {
    @ObservedObject var courseStore: CourseStore
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var location = ""
    @State private var teacherName = ""
    @State private var selectedDay = DayOfWeek.monday
    @State private var startTime = Date()
    @State private var endTime = Date()
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Course Details") {
                    TextField("Course Name", text: $name)
                    TextField("Location", text: $location)
                    TextField("Teacher's Name", text: $teacherName)
                }
                
                Section("Schedule") {
                    Picker("Day", selection: $selectedDay) {
                        ForEach(DayOfWeek.allCases, id: \.self) { day in
                            Text(day.rawValue).tag(day)
                        }
                    }
                    DatePicker("Start Time", selection: $startTime, displayedComponents: .hourAndMinute)
                    DatePicker("End Time", selection: $endTime, displayedComponents: .hourAndMinute)
                }
            }
            .navigationTitle("Add Course")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let course = Course(
                            name: name,
                            location: location,
                            teacherName: teacherName,
                            schedule: Schedule(
                                dayOfWeek: selectedDay,
                                startTime: startTime,
                                endTime: endTime
                            ),
                            todos: []
                        )
                        courseStore.addCourse(course)
                        dismiss()
                    }
                    .disabled(name.isEmpty || location.isEmpty || teacherName.isEmpty)
                }
            }
        }
    }
} 