//
//  HabitStore.swift
//  Levelio
//
//  Created by Irene Ancilla Chow on 14/09/26.
//

import Foundation
import SwiftUI
import Combine
import CoreData

@MainActor
class HabitStore: ObservableObject {
    
    private let habitService: HabitService
    @Published var habits: [HabitEntity] = []
    
    // MARK: - Initialization
    init() {
        self.habitService = .shared
        loadHabits()
    }

    init(context: NSManagedObjectContext) {
        self.habitService = HabitService(context: context)
        loadHabits()
    }
    
    // MARK: - Actions
    func addHabit(title: String, description: String, colorName: String = "cyan", frequency: String = "Daily", time: String = "08.00am") {
        do {
            let _ = try habitService.addHabit(
                title: title,
                description: description,
                colorName: colorName,
                frequency: frequency,
                time: time
            )
            loadHabits()
        } catch {
            print("Failed to add habit: \(error.localizedDescription)")
        }
    }
    
    func toggleCompletion(for habitID: UUID) {
        do {
            try habitService.toggleCompletion(for: habitID)
            loadHabits()
        } catch {
            print("Failed to toggle habit: \(error.localizedDescription)")
        }
    }
    
    func deleteHabit(id: UUID) {
        do {
            try habitService.deleteHabit(id: id)
            loadHabits()
        } catch {
            print("Failed to delete habit: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Private
    private func loadHabits() {
        habits = habitService.loadHabits()
    }
}
