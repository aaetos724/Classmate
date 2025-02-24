import SwiftUI

struct CalendarView: View {
    @StateObject private var courseStore = CourseStore()
    @State private var showingAddCourse = false
    @State private var selectedDay: DayOfWeek = .monday
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Week day selector
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(DayOfWeek.allCases, id: \.self) { day in
                            VStack {
                                Text(day.rawValue.prefix(3))
                                    .fontWeight(selectedDay == day ? .bold : .regular)
                                Circle()
                                    .fill(selectedDay == day ? .blue : .clear)
                                    .frame(width: 4, height: 4)
                            }
                            .onTapGesture {
                                withAnimation { selectedDay = day }
                            }
                        }
                    }
                    .padding()
                }
                .background(Color(.systemBackground))
                
                // Classes for selected day
                List {
                    let coursesForDay = courseStore.coursesForDay(selectedDay)
                    ForEach(coursesForDay) { course in
                        NavigationLink {
                            TodoListView(courseStore: courseStore, courseId: course.id)
                        } label: {
                            CourseRowView(course: course)
                        }
                    }
                    .onDelete { indices in
                        // Convert indices from the filtered array to the main array
                        let coursesToDelete = indices.map { coursesForDay[$0] }
                        let mainIndices = IndexSet(coursesToDelete.compactMap { course in
                            courseStore.courses.firstIndex(where: { $0.id == course.id })
                        })
                        courseStore.deleteCourse(at: mainIndices)
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Schedule")
            .toolbar {
                EditButton()
                Button(action: { showingAddCourse = true }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundStyle(.blue)
                }
            }
            .sheet(isPresented: $showingAddCourse) {
                AddCourseView(courseStore: courseStore)
            }
        }
    }
}

struct CourseRowView: View {
    let course: Course
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(course.name)
                .font(.headline)
            Text(course.location)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(course.teacherName)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text("\(course.schedule.startTime.formatted(date: .omitted, time: .shortened)) - \(course.schedule.endTime.formatted(date: .omitted, time: .shortened))")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 8)
    }
} 