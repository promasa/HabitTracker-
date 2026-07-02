//
//  CounterListView.swift
//  HabitTracker
//

import SwiftUI
import SwiftData

struct CounterListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Counter.startDate) private var counters: [Counter]

    @State private var isAddSheetPresented = false
    @State private var counterToReset: Counter?

    var body: some View {
        NavigationStack {
            Group {
                if counters.isEmpty {
                    ContentUnavailableView(
                        "カウンターがありません",
                        systemImage: "flame",
                        description: Text("右上の + から新しいカウンターを追加しましょう")
                    )
                } else {
                    List {
                        ForEach(counters.indices, id: \.self) { index in
                            let counter = counters[index]
                            if index == 0 {
                                CounterHeroCardView(counter: counter) {
                                    counterToReset = counter
                                }
                            } else {
                                CounterRowView(counter: counter) {
                                    counterToReset = counter
                                }
                            }
                        }
                        .onDelete(perform: deleteCounters)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("継続カウンター")
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
                CounterAddSheet()
            }
            .confirmationDialog(
                "「\(counterToReset?.name ?? "")」をリセットしますか？",
                isPresented: Binding(
                    get: { counterToReset != nil },
                    set: { isPresented in
                        if !isPresented { counterToReset = nil }
                    }
                ),
                titleVisibility: .visible
            ) {
                Button("リセット", role: .destructive) {
                    counterToReset?.startDate = Calendar.current.startOfDay(for: .now)
                    counterToReset = nil
                }
                Button("キャンセル", role: .cancel) {
                    counterToReset = nil
                }
            } message: {
                Text("開始日が今日にリセットされ、経過日数が0日から再開します。")
            }
        }
    }

    private func deleteCounters(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(counters[index])
        }
    }
}

#Preview {
    CounterListView()
        .modelContainer(for: Counter.self, inMemory: true)
}
