//
//  HabitListHeaderView.swift
//  HabitTracker
//

import SwiftUI

struct HabitListHeaderView: View {
    let date: Date
    let completedCount: Int
    let totalCount: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(date.formatted(.dateTime.year().month().day().weekday(.wide)))
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text("\(completedCount) / \(totalCount) 達成")
                .font(.title3.bold())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.orange.opacity(0.12))
        )
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
}

#Preview {
    HabitListHeaderView(date: .now, completedCount: 2, totalCount: 4)
}
