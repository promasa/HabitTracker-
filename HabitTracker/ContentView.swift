//
//  ContentView.swift
//  HabitTracker
//

import SwiftUI
import SwiftData

struct ContentView: View {
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
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Counter.self, Habit.self], inMemory: true)
}
