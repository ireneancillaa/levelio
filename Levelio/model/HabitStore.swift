//
//  HabitStore.swift
//  Levelio
//
//  Created by Irene Ancilla Chow on 14/09/26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class HabitStore: ObservableObject {
    @Published var habits: [Habit] = [] {
        didSet {
            saveHabits()
        }
    }
    
    private let userDefaultsKey = "levelio_user_habits_data"
    
    init() {
        loadHabits()
    }
    
    // MARK: - Persistence Logic
    private func loadHabits() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decoded = try? JSONDecoder().decode([Habit].self, from: data) {
            self.habits = decoded
        } else {
            // Seed initial sample habits if first launch
            self.habits = [
                Habit(
                    title: "Morning Yoga",
                    description: "Stretch and relax for 15 minutes",
                    colorName: "cyan",
                    frequency: "Daily",
                    time: "08.00am",
                    isCompleted: false,
                    xpReward: 50
                ),
                Habit(
                    title: "Read 10 Pages",
                    description: "Daily reading before sleep",
                    colorName: "purple",
                    frequency: "Daily",
                    time: "09.00pm",
                    isCompleted: true,
                    xpReward: 50
                ),
                Habit(
                    title: "Jalan jalan sama iren",
                    description: "Kalo ga jalan nanti ngamuk",
                    colorName: "cyan",
                    frequency: "Daily",
                    time: "09.00pm",
                    isCompleted: true,
                    xpReward: 1000
                ),
            ]
        }
    }
    
    private func saveHabits() {
        if let encoded = try? JSONEncoder().encode(habits) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    // MARK: - CRUD Actions
    func addHabit(title: String, description: String, colorName: String = "cyan", frequency: String = "Daily", time: String = "08.00am") {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }
        
        let newHabit = Habit(
            title: trimmedTitle,
            description: description.trimmingCharacters(in: .whitespacesAndNewlines),
            colorName: colorName,
            frequency: frequency,
            time: time,
            isCompleted: false,
            xpReward: 50
        )
        
        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            habits.insert(newHabit, at: 0)
        }
    }
    
    func toggleCompletion(for habitID: UUID) {
        if let index = habits.firstIndex(where: { $0.id == habitID }) {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                habits[index].isCompleted.toggle()
            }
        }
    }
    
    func deleteHabit(id: UUID) {
        withAnimation {
            habits.removeAll(where: { $0.id == id })
        }
    }
}
