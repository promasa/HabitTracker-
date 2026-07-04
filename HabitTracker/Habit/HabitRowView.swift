//
//  HabitRowView.swift
//  HabitTracker
//

import SwiftUI

struct HabitRowView: View {
    let habit: Habit
    var onToggle: () -> Void
    var onEdit: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            Button(action: onToggle) {
                Image(systemName: habit.isCompletedToday ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 32))
                    .foregroundStyle(habit.isCompletedToday ? Color.orange : Color.secondary)
            }
            .buttonStyle(.plain)

            Button(action: onEdit) {
                HStack(spacing: 8) {
                    Text(habit.name)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    if habit.reminderTime != nil {
                        Image(systemName: "bell.fill")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    HStack(spacing: 4) {
                        Text("🔥")
                        Text("\(habit.streak)")
                            .font(.subheadline.bold())
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.orange.opacity(0.15))
                    )
                    .foregroundStyle(.orange)
                }
            }
            .buttonStyle(.plain)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
    }
}

#Preview {
    HabitRowView(habit: Habit(name: "読書"), onToggle: {}, onEdit: {})
}
