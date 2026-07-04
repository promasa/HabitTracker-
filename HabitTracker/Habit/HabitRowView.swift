//
//  HabitRowView.swift
//  HabitTracker
//

import SwiftUI

struct HabitRowView: View {
    let habit: Habit
    var onToggle: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            Button(action: onToggle) {
                Image(systemName: habit.isCompletedToday ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 32))
                    .foregroundStyle(habit.isCompletedToday ? Color.orange : Color.secondary)
            }
            .buttonStyle(.plain)

            Text(habit.name)
                .font(.headline)

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
    HabitRowView(habit: Habit(name: "読書")) {}
}
