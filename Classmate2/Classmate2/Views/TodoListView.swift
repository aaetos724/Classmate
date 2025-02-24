import SwiftUI

struct TodoListView: View {
    @ObservedObject var courseStore: CourseStore
    let courseId: UUID
    @State private var showingAddTodo = false
    
    // Computed property to get the current course
    private var course: Course? {
        courseStore.courses.first { $0.id == courseId }
    }
    
    var body: some View {
        List {
            if let currentCourse = course {
                ForEach(currentCourse.todos) { todo in
                    TodoRowView(
                        todo: todo,
                        courseStore: courseStore,
                        courseId: courseId
                    )
                }
                .onDelete { indices in
                    courseStore.deleteTodo(for: courseId, at: indices)
                }
            }
        }
        .navigationTitle(course?.name ?? "Tasks")
        .toolbar {
            EditButton()
            Button(action: { showingAddTodo = true }) {
                Image(systemName: "plus")
            }
        }
        .sheet(isPresented: $showingAddTodo) {
            AddTodoView(courseStore: courseStore, courseId: courseId)
        }
    }
}

struct TodoRowView: View {
    let todo: Todo
    @ObservedObject var courseStore: CourseStore
    let courseId: UUID
    
    var body: some View {
        HStack {
            Button(action: {
                courseStore.toggleTodo(for: courseId, todoId: todo.id)
            }) {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(todo.isCompleted ? .green : .gray)
            }
            
            VStack(alignment: .leading) {
                Text(todo.description)
                    .strikethrough(todo.isCompleted)
                if let dueDate = todo.dueDate {
                    Text(dueDate.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
} 