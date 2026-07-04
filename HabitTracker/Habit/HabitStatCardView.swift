//
//  HabitStatCardView.swift
//  HabitTracker
//

import SwiftUI

struct HabitStatCardView: View {
    let title: String
    let value: String
    let systemImage: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: systemImage)
                .font(.title3)
                .foregroundStyle(.orange)

            Text(value)
                .font(.title2.bold())

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

#Preview {
    HStack(spacing: 12) {
        HabitStatCardView(title: "現在の連続日数", value: "5日", systemImage: "flame.fill")
        HabitStatCardView(title: "最長連続日数", value: "12日", systemImage: "trophy.fill")
        HabitStatCardView(title: "累計達成日数", value: "30日", systemImage: "checkmark.seal.fill")
    }
    .padding()
}
