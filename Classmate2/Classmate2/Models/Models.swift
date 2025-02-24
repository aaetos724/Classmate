import Foundation

struct Course: Identifiable, Codable {
    var id = UUID()
    var name: String
    var location: String
    var teacherName: String
    var schedule: Schedule
    var todos: [Todo]
}

struct Schedule: Codable {
    var dayOfWeek: DayOfWeek
    var startTime: Date
    var endTime: Date
}

enum DayOfWeek: String, Codable, CaseIterable {
    case monday = "Monday"
    case tuesday = "Tuesday"
    case wednesday = "Wednesday"
    case thursday = "Thursday"
    case friday = "Friday"
}

struct Todo: Identifiable, Codable {
    var id = UUID()
    var description: String
    var dueDate: Date?
    var isCompleted: Bool
} 