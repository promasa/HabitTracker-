//
//  CounterHeroCardView.swift
//  HabitTracker
//

import SwiftUI

struct CounterHeroCardView: View {
    let counter: Counter
    var onReset: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(counter.name)
                .font(.title2.bold())
                .foregroundStyle(.primary)

            HStack(alignment: .lastTextBaseline, spacing: 6) {
                Text("\(counter.elapsedDays)")
                    .font(.system(size: 64, weight: .bold, design: .rounded))
                    .foregroundStyle(.orange)
                Text("日")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }

            Text("開始日: \(counter.startDate.formatted(.dateTime.year().month().day()))")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Button(role: .destructive) {
                onReset()
            } label: {
                Label("リセット", systemImage: "arrow.counterclockwise")
                    .font(.subheadline.weight(.semibold))
            }
            .buttonStyle(.bordered)
            .tint(.orange)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.orange.opacity(0.12))
        )
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

#Preview {
    CounterHeroCardView(counter: Counter(name: "禁煙", startDate: .now)) {}
}
