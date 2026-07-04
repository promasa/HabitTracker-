//
//  HabitDetailView.swift
//  HabitTracker
//

import SwiftUI

struct HabitDetailView: View {
    @Bindable var habit: Habit
    @State private var isEditSheetPresented = false
    @State private var displayedMonth: Date = Calendar.current.startOfDay(for: .now)

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(habit.name)
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)

                HStack(spacing: 12) {
                    HabitStatCardView(
                        title: "現在の連続日数",
                        value: "\(habit.streak)日",
                        systemImage: "flame.fill"
                    )
                    HabitStatCardView(
                        title: "最長連続日数",
                        value: "\(habit.longestStreak)日",
                        systemImage: "trophy.fill"
                    )
                    HabitStatCardView(
                        title: "累計達成日数",
                        value: "\(habit.totalCompletedDays)日",
                        systemImage: "checkmark.seal.fill"
                    )
                }
                .padding(.horizontal, 16)

                HabitCalendarView(habit: habit, displayedMonth: $displayedMonth)
            }
            .padding(.vertical, 16)
        }
        .navigationTitle("習慣の詳細")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("編集") {
                    isEditSheetPresented = true
                }
            }
        }
        .sheet(isPresented: $isEditSheetPresented) {
            HabitEditSheet(habit: habit)
        }
    }
}

#Preview {
    NavigationStack {
        HabitDetailView(habit: Habit(name: "読書"))
    }
    .modelContainer(for: Habit.self, inMemory: true)
}
