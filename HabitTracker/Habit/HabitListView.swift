//
//  HabitListView.swift
//  HabitTracker
//

import SwiftUI
import SwiftData

struct HabitListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Habit.createdAt) private var habits: [Habit]

    @State private var isAddSheetPresented = false

    private var completedTodayCount: Int {
        habits.filter(\.isCompletedToday).count
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HabitListHeaderView(
                    date: .now,
                    completedCount: completedTodayCount,
                    totalCount: habits.count
                )

                if habits.isEmpty {
                    ContentUnavailableView(
                        "習慣がありません",
                        systemImage: "checklist",
                        description: Text("右上の + から新しい習慣を追加しましょう")
                    )
                    .frame(maxHeight: .infinity)
                } else {
                    List {
                        ForEach(habits) { habit in
                            HabitRowView(habit: habit) {
                                habit.toggleToday()
                            }
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.clear)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    modelContext.delete(habit)
                                } label: {
                                    Label("削除", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("習慣")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isAddSheetPresented = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isAddSheetPresented) {
                HabitAddSheet()
            }
        }
    }

}

#Preview {
    HabitListView()
        .modelContainer(for: Habit.self, inMemory: true)
}
