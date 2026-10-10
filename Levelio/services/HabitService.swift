//
//  HabitService.swift
//  Levelio
//
//  Created by Refactor on 10/10/26.
//

import Foundation
import CoreData

/// Service class untuk seluruh operasi habit (business logic).
/// Single source of truth untuk CRUD dan persistence habits.
@MainActor
class HabitService {
    
    private let viewContext: NSManagedObjectContext
    private let userDefaultsKey = "levelio_user_habits_data"
    
    // MARK: - Initialization
    init(context: NSManagedObjectContext) {
        self.viewContext = context
    }
    
    /// Convenience initializer dengan shared PersistenceController.
    static let shared = HabitService(context: PersistenceController.shared.container.viewContext)
    
    // MARK: - CRUD Operations
    
    /// Menambahkan habit baru ke user yang sedang login.
    /// - Parameters:
    ///   - title: Nama habit (wajib tidak kosong).
    ///   - description: Deskripsi habit (opsional).
    ///   - colorName: Warna habit dari Assets.xcassets.
    ///   - frequency: Frekuensi pelaksanaan ("Daily" atau "Weekly").
    ///   - time: Waktu pengingat dalam format "HH.mmam"/"HH.mmpm".
    /// - Returns: UUID dari habit yang baru dibuat.
    /// - Throws: Error jika user tidak ditemukan atau save gagal.
    func addHabit(title: String, description: String, colorName: String = "cyan", frequency: String = "Daily", time: String = "08.00am") throws -> UUID {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else {
            throw HabitError.emptyHabitTitle
        }
        
        guard let userIdString = UserDefaults.standard.string(forKey: "currentUserId"),
              let userUUID = UUID(uuidString: userIdString) else {
            print("Error: currentUserId not found")
            throw HabitError.userNotFound
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
        
        try viewContext.save()
        return newHabit.habitId!
    }
    
    /// Toggle status completed habit.
    /// - Parameter habitID: UUID dari habit yang ingin ditoggle.
    func toggleCompletion(for habitID: UUID) throws {
        let request: NSFetchRequest<HabitEntity> = HabitEntity.fetchRequest()
        request.predicate = NSPredicate(format: "habitId == %@", habitID as CVarArg)
        request.fetchLimit = 1
        
        guard let habit = try viewContext.fetch(request).first else {
            print("Error: habit with ID \(habitID) not found")
            throw HabitError.habitNotFound(habitID)
        }
        
        habit.isCompleted.toggle()
        try saveContext()
    }
    
    /// Menghapus habit berdasarkan ID.
    /// - Parameter id: UUID dari habit yang ingin dihapus.
    func deleteHabit(id: UUID) throws {
        let request: NSFetchRequest<HabitEntity> = HabitEntity.fetchRequest()
        request.predicate = NSPredicate(format: "habitId == %@", id as CVarArg)
        request.fetchLimit = 1
        
        guard let habitToDelete = try viewContext.fetch(request).first else {
            print("Error: habit with ID \(id) not found")
            throw HabitError.habitNotFound(id)
        }
        
        viewContext.delete(habitToDelete)
        try saveContext()
    }
    
    // MARK: - Persistence & Fetching
    
    /// Memuat semua habit untuk user yang sedang login.
    /// - Returns: Array habit terurut berdasarkan title (ascending).
    func loadHabits() -> [HabitEntity] {
        guard let userIdString = UserDefaults.standard.string(forKey: "currentUserId"),
              let userUUID = UUID(uuidString: userIdString) else {
            print("Error: currentUserId not found")
            return []
        }
        
        let request: NSFetchRequest<HabitEntity> = HabitEntity.fetchRequest()
        request.predicate = NSPredicate(format: "userId == %@", userUUID as CVarArg)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \HabitEntity.title, ascending: true)]
        
        do {
            let fetchedHabits = try viewContext.fetch(request)
            return fetchedHabits
        } catch {
            print("Failed to fetch habits: \(error.localizedDescription)")
            return []
        }
    }
    
    /// Filter habit berdasarkan status completed.
    /// - Parameter isCompleted: true untuk past progress, false untuk today's progress.
    /// - Returns: Array habit sesuai filter.
    func habitsByStatus(isCompleted: Bool) -> [HabitEntity] {
        return loadHabits().filter { $0.isCompleted == isCompleted }
    }
    
    // MARK: - Active Habit Count
    
    /// Menghitung jumlah habit yang aktif (belum completed).
    /// Habit aktif = habit dengan isCompleted == false.
    /// - Returns: Jumlah habit yang masih aktif.
    func getActiveHabitCount() -> Int {
        let allHabits = loadHabits()
        return allHabits.filter { !$0.isCompleted }.count
    }
    
    // MARK: - Completion Calculation
    
    /// Menghitung completion percentage dari habit user.
    /// - Formula: (Total Habit Completed / Total Habit) × 100
    /// - Returns: Integer 0-100, atau 0 jika tidak ada habit sama sekali.
    func calculateCompletionPercentage() -> Int {
        let allHabits = loadHabits()
        
        // Jika tidak ada habit, return 0%
        guard !allHabits.isEmpty else {
            return 0
        }
        
        let totalHabits = allHabits.count
        let completedHabits = allHabits.filter { $0.isCompleted }.count
        
        // Hitung percentage dengan pembulatan ke integer terdekat
        let percentage = Int(Double(completedHabits) / Double(totalHabits) * 100)
        
        return percentage
    }
    
    // MARK: - Private Helpers
    
    private func saveContext() throws {
        do {
            try viewContext.save()
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
            throw HabitError.saveFailed
        }
    }
}

// MARK: - Errors

enum HabitError: Error, LocalizedError {
    case emptyHabitTitle
    case userNotFound
    case habitNotFound(UUID)
    case saveFailed
    
    var errorDescription: String? {
        switch self {
        case .emptyHabitTitle:
            return "Habit name cannot be empty"
        case .userNotFound:
            return "User not found. Please login first."
        case .saveFailed:
            return "Failed to save habit data. Please try again."
        case .habitNotFound(let id):
            return "Habit with ID \(id.uuidString) not found"
        }
    }
}
