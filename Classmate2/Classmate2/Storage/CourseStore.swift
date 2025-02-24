import Foundation

@MainActor
class CourseStore: ObservableObject {
    @Published private(set) var courses: [Course] = []
    @Published var isLoading = false
    @Published var lastError: String?
    
    private let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedCourses")
    
    init() {
        loadCourses()
    }
    
    func loadCourses() {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let data = try Data(contentsOf: savePath)
            courses = try JSONDecoder().decode([Course].self, from: data)
            lastError = nil
        } catch {
            lastError = "Failed to load courses: \(error.localizedDescription)"
            courses = []
        }
    }
    
    func saveCourses() {
        do {
            let data = try JSONEncoder().encode(courses)
            try data.write(to: savePath, options: [.atomicWrite, .completeFileProtection])
            lastError = nil
            objectWillChange.send() // Ensure UI updates
        } catch {
            lastError = "Failed to save courses: \(error.localizedDescription)"
        }
    }
    
    // MARK: - Course Operations
    func addCourse(_ course: Course) {
        courses.append(course)
        saveCourses()
    }
    
    func deleteCourse(at offsets: IndexSet) {
        courses.remove(atOffsets: offsets)
        saveCourses()
    }
    
    // MARK: - Todo Operations
    func addTodo(for courseId: UUID, description: String, dueDate: Date?) {
        if let index = courses.firstIndex(where: { $0.id == courseId }) {
            let todo = Todo(description: description, dueDate: dueDate, isCompleted: false)
            courses[index].todos.append(todo)
            saveCourses()
        }
    }
    
    func deleteTodo(for courseId: UUID, at offsets: IndexSet) {
        if let index = courses.firstIndex(where: { $0.id == courseId }) {
            courses[index].todos.remove(atOffsets: offsets)
            saveCourses()
        }
    }
    
    func updateTodo(for courseId: UUID, todoId: UUID, isCompleted: Bool) {
        if let courseIndex = courses.firstIndex(where: { $0.id == courseId }),
           let todoIndex = courses[courseIndex].todos.firstIndex(where: { $0.id == todoId }) {
            courses[courseIndex].todos[todoIndex].isCompleted = isCompleted
            saveCourses()
        }
    }
    
    func coursesForDay(_ day: DayOfWeek) -> [Course] {
        courses.filter { $0.schedule.dayOfWeek == day }
            .sorted { $0.schedule.startTime < $1.schedule.startTime }
    }
    
    func toggleTodo(for courseId: UUID, todoId: UUID) {
        if let courseIndex = courses.firstIndex(where: { $0.id == courseId }),
           let todoIndex = courses[courseIndex].todos.firstIndex(where: { $0.id == todoId }) {
            courses[courseIndex].todos[todoIndex].isCompleted.toggle()
            saveCourses()
        }
    }
} 