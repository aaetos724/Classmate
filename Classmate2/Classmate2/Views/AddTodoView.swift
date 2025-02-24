import SwiftUI

struct AddTodoView: View {
    @ObservedObject var courseStore: CourseStore
    let courseId: UUID
    @Environment(\.dismiss) var dismiss
    
    @State private var description = ""
    @State private var hasDueDate = false
    @State private var dueDate = Date()
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Task Description", text: $description)
                
                Toggle("Has Due Date", isOn: $hasDueDate)
                
                if hasDueDate {
                    DatePicker("Due Date", selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
                }
            }
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        courseStore.addTodo(
                            for: courseId,
                            description: description,
                            dueDate: hasDueDate ? dueDate : nil
                        )
                        dismiss()
                    }
                    .disabled(description.isEmpty)
                }
            }
        }
    }
} 