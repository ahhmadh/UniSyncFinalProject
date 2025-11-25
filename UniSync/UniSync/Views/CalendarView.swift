//
//  CalendarView.swift
//  UniSync
//
//  Created by Ahmad Hassan on 2025-11-24.
//


import SwiftUI

struct CalendarView: View {
    @StateObject private var assignmentsVM = AssignmentsViewModel()
    @StateObject private var coursesVM = CoursesViewModel()
    @State private var selectedDate = Date()
    @State private var currentMonth = Date()

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                // MARK: - Month Header
                HStack {
                    Button(action: { changeMonth(-1) }) {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                    }
                    Spacer()
                    Text(monthYearFormatter.string(from: currentMonth))
                        .font(.headline)
                    Spacer()
                    Button(action: { changeMonth(1) }) {
                        Image(systemName: "chevron.right")
                            .font(.title3)
                    }
                }
                .padding(.horizontal)

                // MARK: - Calendar Grid
                let days = generateDays(for: currentMonth)
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 12) {
                    ForEach(days, id: \.self) { day in
                        VStack(spacing: 4) {
                            Text("\(Calendar.current.component(.day, from: day))")
                                .font(.body)
                                .foregroundColor(Calendar.current.isDateInToday(day) ? .blue : .primary)
                                .frame(width: 30, height: 30)
                                .background(
                                    Calendar.current.isDate(selectedDate, inSameDayAs: day)
                                    ? Circle().fill(Color.blue.opacity(0.2))
                                    : nil
                                )
                                .onTapGesture {
                                    selectedDate = day
                                }

                            // 🔵 Dot under days that have assignments due
                            if hasAssignment(on: day) {
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 6, height: 6)
                            } else {
                                Circle()
                                    .fill(Color.clear)
                                    .frame(width: 6, height: 6)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .padding(.horizontal)

                Divider().padding(.vertical, 5)

                // MARK: - Assignments List
                List {
                    Section(header: Text("Assignments on \(formatted(selectedDate))")) {
                        let todays = assignmentsOn(selectedDate)
                        if todays.isEmpty {
                            Text("No assignments due on this day.")
                                .foregroundStyle(.secondary)
                        } else {
                            ForEach(todays) { a in
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(a.title).font(.headline)
                                        if let course = coursesVM.courses.first(where: { $0.id == a.courseId }) {
                                            Text(course.name)
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                        }
                                        Text("Due: \(formatted(a.dueDate))")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Circle()
                                        .fill(priorityColor(a.priority))
                                        .frame(width: 10, height: 10)
                                }
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Calendar")
            .onAppear {
                coursesVM.loadCourses()
                assignmentsVM.loadAssignments()
            }
        }
    }

    // MARK: - Helpers

    private func assignmentsOn(_ date: Date) -> [Assignment] {
        let cal = Calendar.current
        return assignmentsVM.assignments.filter { a in
            cal.isDate(a.dueDate, inSameDayAs: date)
        }
    }

    private func hasAssignment(on date: Date) -> Bool {
        let cal = Calendar.current
        return assignmentsVM.assignments.contains { a in
            cal.isDate(a.dueDate, inSameDayAs: date)
        }
    }

    private func formatted(_ date: Date) -> String {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df.string(from: date)
    }

    private func changeMonth(_ value: Int) {
        if let newMonth = Calendar.current.date(byAdding: .month, value: value, to: currentMonth) {
            currentMonth = newMonth
        }
    }

    private func generateDays(for month: Date) -> [Date] {
        let calendar = Calendar.current
        guard
            let monthInterval = calendar.dateInterval(of: .month, for: month),
            let startWeekday = calendar.dateComponents([.weekday], from: monthInterval.start).weekday
        else { return [] }

        var days: [Date] = []
        // Add leading empty days
        for _ in 1..<startWeekday { days.append(Date.distantPast) }

        let range = calendar.range(of: .day, in: .month, for: month)!
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: monthInterval.start) {
                days.append(date)
            }
        }
        return days
    }

    private var monthYearFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "LLLL yyyy"
        return df
    }

    private func priorityColor(_ priority: Priority) -> Color {
        switch priority {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        }
    }
}

extension Date {
    func isSameDay(as other: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: other)
    }
}
