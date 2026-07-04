//
//  CounterAddSheet.swift
//  HabitTracker
//

import SwiftUI
import SwiftData

struct CounterAddSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Counter.sortOrder) private var counters: [Counter]

    @State private var name: String = ""
    @State private var startDate: Date = Calendar.current.startOfDay(for: .now)

    private var isValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("名前") {
                    TextField("例: 禁煙", text: $name)
                }
                Section("開始日") {
                    DatePicker("開始日", selection: $startDate, displayedComponents: .date)
                }
            }
            .navigationTitle("カウンターを追加")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("追加") { addCounter() }
                        .disabled(!isValid)
                }
            }
        }
    }

    private func addCounter() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let nextSortOrder = (counters.map(\.sortOrder).max() ?? -1) + 1
        let counter = Counter(name: trimmedName, startDate: startDate, sortOrder: nextSortOrder)
        modelContext.insert(counter)
        dismiss()
    }
}

#Preview {
    CounterAddSheet()
        .modelContainer(for: Counter.self, inMemory: true)
}
