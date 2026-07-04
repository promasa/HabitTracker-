//
//  CounterRowView.swift
//  HabitTracker
//

import SwiftUI

struct CounterRowView: View {
    let counter: Counter
    var onReset: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(counter.name)
                    .font(.headline)
                Text("開始日: \(counter.startDate.formatted(.dateTime.year().month().day()))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("最高 \(counter.displayedLongestRecord)日")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text("\(counter.elapsedDays)日")
                .font(.title3.bold())
                .foregroundStyle(.orange)

            Button {
                onReset()
            } label: {
                Image(systemName: "arrow.counterclockwise")
            }
            .buttonStyle(.borderless)
            .tint(.orange)
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
    CounterRowView(counter: Counter(name: "早起き", startDate: .now)) {}
}
