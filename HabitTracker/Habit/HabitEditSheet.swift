//
//  HabitEditSheet.swift
//  HabitTracker
//

import SwiftUI

struct HabitEditSheet: View {
    @Bindable var habit: Habit
    @Environment(\.dismiss) private var dismiss

    @State private var name: String
    @State private var isReminderOn: Bool
    @State private var reminderTime: Date

    init(habit: Habit) {
        self.habit = habit
        _name = State(initialValue: habit.name)
        _isReminderOn = State(initialValue: habit.reminderTime != nil)
        _reminderTime = State(
            initialValue: habit.reminderTime ?? Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: .now) ?? .now
        )
    }

    private var isValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("名前") {
                    TextField("例: 読書", text: $name)
                }
                Section {
                    Toggle("毎日リマインド", isOn: $isReminderOn)
                    if isReminderOn {
                        DatePicker("時刻", selection: $reminderTime, displayedComponents: .hourAndMinute)
                    }
                }
            }
            .navigationTitle("習慣を編集")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        Task { await save() }
                    }
                    .disabled(!isValid)
                }
            }
        }
    }

    private func save() async {
        habit.name = name.trimmingCharacters(in: .whitespacesAndNewlines)

        if isReminderOn {
            if await NotificationManager.shared.authorizationStatus() == .notDetermined {
                _ = await NotificationManager.shared.requestAuthorization()
            }
            habit.reminderTime = reminderTime
            NotificationManager.shared.schedule(for: habit)
        } else {
            habit.reminderTime = nil
            NotificationManager.shared.cancel(for: habit)
        }

        dismiss()
    }
}

#Preview {
    HabitEditSheet(habit: Habit(name: "読書"))
        .modelContainer(for: Habit.self, inMemory: true)
}
