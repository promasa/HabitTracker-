//
//  HabitCalendarView.swift
//  HabitTracker
//

import SwiftUI

struct HabitCalendarView: View {
    let habit: Habit
    @Binding var displayedMonth: Date

    private let calendar = Calendar.current
    private let weekdaySymbols = ["日", "月", "火", "水", "木", "金", "土"]
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)

    private var completedDays: Set<Date> {
        Set(habit.completedDates.map { calendar.startOfDay(for: $0) })
    }

    private var isDisplayingCurrentMonth: Bool {
        calendar.isDate(displayedMonth, equalTo: .now, toGranularity: .month)
    }

    private var monthTitle: String {
        displayedMonth.formatted(.dateTime.year().month(.wide))
    }

    private var daysInGrid: [Date?] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: displayedMonth) else { return [] }

        let weekdayOfFirstDay = calendar.component(.weekday, from: monthInterval.start)
        let leadingEmptyCount = weekdayOfFirstDay - 1
        let dayCount = calendar.range(of: .day, in: .month, for: displayedMonth)?.count ?? 0

        var days: [Date?] = Array(repeating: nil, count: leadingEmptyCount)
        for dayOffset in 0..<dayCount {
            if let date = calendar.date(byAdding: .day, value: dayOffset, to: monthInterval.start) {
                days.append(date)
            }
        }
        return days
    }

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Button {
                    changeMonth(by: -1)
                } label: {
                    Image(systemName: "chevron.left")
                }

                Spacer()

                Text(monthTitle)
                    .font(.headline)

                Spacer()

                Button {
                    changeMonth(by: 1)
                } label: {
                    Image(systemName: "chevron.right")
                }
                .disabled(isDisplayingCurrentMonth)
            }

            HStack {
                ForEach(weekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }

            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(Array(daysInGrid.enumerated()), id: \.offset) { _, date in
                    if let date {
                        dayCell(for: date)
                    } else {
                        Color.clear
                            .frame(height: 36)
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
        .padding(.horizontal, 16)
    }

    private func dayCell(for date: Date) -> some View {
        let day = calendar.startOfDay(for: date)
        let isCompleted = completedDays.contains(day)
        let isToday = calendar.isDateInToday(day)

        return Text("\(calendar.component(.day, from: day))")
            .font(.subheadline)
            .foregroundStyle(isCompleted ? .white : .primary)
            .frame(height: 36)
            .frame(maxWidth: .infinity)
            .background(
                Circle()
                    .fill(isCompleted ? Color.orange : Color.clear)
            )
            .overlay(
                Circle()
                    .strokeBorder(isToday ? Color.orange : Color.clear, lineWidth: 2)
            )
    }

    private func changeMonth(by value: Int) {
        guard let newMonth = calendar.date(byAdding: .month, value: value, to: displayedMonth) else { return }
        displayedMonth = newMonth
    }
}

#Preview {
    HabitCalendarView(habit: Habit(name: "読書"), displayedMonth: .constant(.now))
}
