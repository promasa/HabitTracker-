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
                        if let firstCounter = counters.first {
                            CounterHeroCardView(counter: firstCounter) {
                                counterToReset = firstCounter
                            }
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.clear)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    modelContext.delete(firstCounter)
                                } label: {
                                    Label("削除", systemImage: "trash")
                                }
                            }
                        }

                        ForEach(restCounters) { counter in
                            CounterRowView(counter: counter) {
                                counterToReset = counter
                            }
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.clear)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    modelContext.delete(counter)
                                } label: {
                                    Label("削除", systemImage: "trash")
                                }
                            }
                        }
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

    private var restCounters: [Counter] {
        Array(counters.dropFirst())
    }
}

#Preview {
    CounterListView()
        .modelContainer(for: Counter.self, inMemory: true)
}
