//
//  ContentView.swift
//  HabitTracker
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var habits: [Habit]

    var body: some View {
        TabView {
            CounterListView()
                .tabItem {
                    Label("継続カウンター", systemImage: "flame")
                }

            HabitListView()
                .tabItem {
                    Label("習慣", systemImage: "checklist")
                }
        }
        .task {
            NotificationManager.shared.rescheduleAll(habits: habits)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Counter.self, Habit.self], inMemory: true)
}
