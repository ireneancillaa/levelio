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
    private let viewContext: NSManagedObjectContext
    
    @Published var habits: [HabitEntity] = []
    
    private let userDefaultsKey = "levelio_user_habits_data"
    
    init() {
        self.viewContext = PersistenceController.shared.container.viewContext
        loadHabits()
    }
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        loadHabits()
    }
    
    // MARK: - Persistence Logic
    private func loadHabits() {
        guard let userIdString = UserDefaults.standard.string(forKey: "currentUserId"),
              let userUUID = UUID(uuidString: userIdString) else {
            print("Error: currentUserId not found")
            self.habits = []
            return
        }
        
        let request: NSFetchRequest<HabitEntity> = HabitEntity.fetchRequest()
        request.predicate = NSPredicate(format: "userId == %@", userUUID as CVarArg)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \HabitEntity.title, ascending: true)]
        
        do {
            let fetchedHabits = try viewContext.fetch(request)
            
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                self.habits = fetchedHabits
            }
        } catch {
            print("Failed to fetch habits: \(error.localizedDescription)")
            self.habits = []
        }
    }
    
    // MARK: - CRUD Actions
    func addHabit(title: String, description: String, colorName: String = "cyan", frequency: String = "Daily", time: String = "08.00am") {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }
        
        guard let userIdString = UserDefaults.standard.string(forKey: "currentUserId"),
              let userUUID = UUID(uuidString: userIdString) else {
            print("Error: currentUserId not found")
            return
        }
        
        let newHabit = HabitEntity(context: viewContext)
            newHabit.habitId = UUID()
            newHabit.userId = userUUID
            newHabit.title = trimmedTitle
            newHabit.desc = description.trimmingCharacters(in: .whitespacesAndNewlines)
            newHabit.colorName = colorName
            newHabit.frequency = frequency
            newHabit.time = time
            newHabit.isCompleted = false
            newHabit.xpReward = 100
        
        do {
            try viewContext.save()
            
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                loadHabits()
            }
        } catch {
            print("Failed to save habit to CoreData: \(error.localizedDescription)")
        }
    }
    
    func toggleCompletion(for habitID: UUID) {
        if let habit = habits.first(where: { $0.habitId == habitID }) {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                objectWillChange.send()
                habit.isCompleted.toggle()
                saveContext()
            }
        }
    }
    
    func deleteHabit(id: UUID) {
        if let habitToDelete = habits.first(where: {$0.habitId == id}) {
            viewContext.delete(habitToDelete)
            saveContext()
        }
        
        withAnimation {
            loadHabits()
        }
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
}
