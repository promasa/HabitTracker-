//
//  HabitAddSheet.swift
//  HabitTracker
//

import SwiftUI
import SwiftData

struct HabitAddSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""

    private var isValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("名前") {
                    TextField("例: 読書", text: $name)
                }
            }
            .navigationTitle("習慣を追加")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("追加") { addHabit() }
                        .disabled(!isValid)
                }
            }
        }
    }

    private func addHabit() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let habit = Habit(name: trimmedName)
        modelContext.insert(habit)
        dismiss()
    }
}

#Preview {
    HabitAddSheet()
        .modelContainer(for: Habit.self, inMemory: true)
}
