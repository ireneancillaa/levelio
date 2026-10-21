//
//  HabitService.swift
//  Levelio
//
//  Created by Refactor on 10/10/26.
//

import Foundation
import CoreData

@MainActor
class HabitService {
    
    private let viewContext: NSManagedObjectContext
    private let userDefaultsKey = "levelio_user_habits_data"
    
    // MARK: - Initialization
    init(context: NSManagedObjectContext) {
        self.viewContext = context
    }
    
    // Convenience initializer dengan shared PersistenceController.
    static let shared = HabitService(context: PersistenceController.shared.container.viewContext)
    
    // MARK: - CRUD Operations
    func addHabit(title: String, description: String, colorName: String = "primary", frequency: String = "Daily", time: String = "08.00am") throws -> UUID {
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
    
    func toggleCompletion(for habitID: UUID) throws {
        let request: NSFetchRequest<HabitEntity> = HabitEntity.fetchRequest()
        request.predicate = NSPredicate(format: "habitId == %@", habitID as CVarArg)
        request.fetchLimit = 1
        
        guard let habit = try viewContext.fetch(request).first else {
            throw HabitError.habitNotFound(habitID)
        }
        
        habit.isCompleted.toggle()
        
        let reward: Int64 = habit.xpReward > 0 ? habit.xpReward : 100
        
        var targetUser: UserEntity?
        if let userId = habit.userId {
            let userRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
            userRequest.predicate = NSPredicate(format: "id == %@", userId as CVarArg)
            targetUser = try viewContext.fetch(userRequest).first
        } else if let userIdString = UserDefaults.standard.string(forKey: "currentUserId"),
                  let userUUID = UUID(uuidString: userIdString) {
            let userRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
            userRequest.predicate = NSPredicate(format: "id == %@", userUUID as CVarArg)
            targetUser = try viewContext.fetch(userRequest).first
        }
        
        if let user = targetUser {
            if habit.isCompleted {
                user.xp += reward
                updateStreak(for: user)
            } else {
                user.xp = max(0, user.xp - reward)
                revertStreakIfNeeded(for: user)
            }
        }
        
        try saveContext()
    }
    
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
    
    func resetAllHabitsCompletion(for user: UserEntity?) throws {
        let allHabits = loadHabits()
        for habit in allHabits {
            habit.isCompleted = false
        }
        try saveContext()
    }
    
    func addBonusXP(amount: Int64, for user: UserEntity) throws {
        user.xp += amount
        try saveContext()
    }
    
    // MARK: - Persistence & Fetching
    static func parseTimeToMinutes(_ timeString: String?) -> Int {
        guard let raw = timeString?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(), !raw.isEmpty else {
            return Int.max
        }
        
        // Normalisasi format pemisah titik menjadi titik dua (misal: "08.00am" -> "08:00am")
        let normalized = raw.replacingOccurrences(of: ".", with: ":")
        
        let formats = ["hh:mma", "hh:mm a", "h:mma", "h:mm a", "HH:mm", "H:mm"]
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0) ?? .current
        
        for format in formats {
            formatter.dateFormat = format
            if let date = formatter.date(from: normalized) {
                let hour = calendar.component(.hour, from: date)
                let minute = calendar.component(.minute, from: date)
                return hour * 60 + minute
            }
        }
        
        return Int.max
    }
    
    func loadHabits() -> [HabitEntity] {
        guard let userIdString = UserDefaults.standard.string(forKey: "currentUserId"),
              let userUUID = UUID(uuidString: userIdString) else {
            print("Error: currentUserId not found")
            return []
        }
        
        let request: NSFetchRequest<HabitEntity> = HabitEntity.fetchRequest()
        request.predicate = NSPredicate(format: "userId == %@", userUUID as CVarArg)
        
        do {
            let fetchedHabits = try viewContext.fetch(request)
            return fetchedHabits.sorted { h1, h2 in
                let time1 = HabitService.parseTimeToMinutes(h1.time)
                let time2 = HabitService.parseTimeToMinutes(h2.time)
                if time1 != time2 {
                    return time1 < time2
                }
                return (h1.title ?? "").localizedCaseInsensitiveCompare(h2.title ?? "") == .orderedAscending
            }
        } catch {
            print("Failed to fetch habits: \(error.localizedDescription)")
            return []
        }
    }
    
    func habitsByStatus(isCompleted: Bool) -> [HabitEntity] {
        return loadHabits().filter { $0.isCompleted == isCompleted }
    }
    
    // MARK: - Active Habit Count
    func getActiveHabitCount() -> Int {
        let allHabits = loadHabits()
        return allHabits.filter { !$0.isCompleted }.count
    }
    
    // MARK: - Completion Calculation
    func calculateCompletionPercentage() -> Int {
        let allHabits = loadHabits()
        
        guard !allHabits.isEmpty else {
            return 0
        }
        
        let totalHabits = allHabits.count
        let completedHabits = allHabits.filter { $0.isCompleted }.count
        
        let percentage = Int(Double(completedHabits) / Double(totalHabits) * 100)
        return percentage
    }
    
    // MARK: - Streak Calculation & Updates
    func updateStreak(for user: UserEntity) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        guard let lastActive = user.lastActiveDate.map({ calendar.startOfDay(for: $0) }) else {
            user.streak = 1
            user.lastActiveDate = Date()
            if user.streak > user.bestStreak {
                user.bestStreak = user.streak
            }
            return
        }
        
        let numberOfDays = calendar.dateComponents([.day], from: lastActive, to: today).day ?? 0
        
        if numberOfDays == 1 {
            user.streak += 1
            user.lastActiveDate = Date()
        } else if numberOfDays > 1 {
            user.streak = 1
            user.lastActiveDate = Date()
        } else if numberOfDays == 0 {
            user.lastActiveDate = Date()
        }
        
        if user.streak > user.bestStreak {
            user.bestStreak = user.streak
        }
    }
    
    func revertStreakIfNeeded(for user: UserEntity) {
        let allHabits = loadHabits()
        let completedToday = allHabits.filter { $0.isCompleted }
        if completedToday.isEmpty {
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())
            if let lastActive = user.lastActiveDate.map({ calendar.startOfDay(for: $0) }),
               calendar.isDate(lastActive, inSameDayAs: today) {
                user.streak = max(0, user.streak - 1)
                if user.streak == 0 {
                    user.lastActiveDate = nil
                }
            }
        }
    }
    
    func calculateCurrentStreak(for user: UserEntity?) -> Int {
        guard let user = user, let lastActive = user.lastActiveDate else { return 0 }
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let lastActiveDay = calendar.startOfDay(for: lastActive)
        
        let numberOfDays = calendar.dateComponents([.day], from: lastActiveDay, to: today).day ?? 0
        
        if numberOfDays > 1 {
            user.streak = 0
            try? viewContext.save()
            return 0
        }
        
        return Int(user.streak)
    }
    
    func getBestStreak(for user: UserEntity?) -> Int {
        guard let user = user else { return 0 }
        let current = calculateCurrentStreak(for: user)
        let best = Int(user.bestStreak)
        if current > best {
            user.bestStreak = Int64(current)
            try? viewContext.save()
            return current
        }
        return max(best, current)
    }
    
    func getActiveDaysInMonth(for date: Date, user: UserEntity?) -> Set<Int> {
        var activeDays = Set<Int>()
        let calendar = Calendar.current
        
        guard let user = user, let lastActive = user.lastActiveDate, user.streak > 0 else {
            let completedHabits = loadHabits().filter { $0.isCompleted }
            if !completedHabits.isEmpty {
                let currentDay = calendar.component(.day, from: Date())
                let isSameMonth = calendar.isDate(date, equalTo: Date(), toGranularity: .month)
                if isSameMonth {
                    activeDays.insert(currentDay)
                }
            }
            return activeDays
        }
        
        let streakCount = Int(user.streak)
        for dayOffset in 0..<streakCount {
            if let activeDate = calendar.date(byAdding: .day, value: -dayOffset, to: lastActive) {
                let isSameMonth = calendar.isDate(date, equalTo: activeDate, toGranularity: .month)
                if isSameMonth {
                    let dayNumber = calendar.component(.day, from: activeDate)
                    activeDays.insert(dayNumber)
                }
            }
        }
        
        return activeDays
    }
    
    // MARK: - XP Calculations
    func calculateTotalXP(for user: UserEntity?) -> Int {
        if let user = user {
            if user.xp > 0 {
                return Int(user.xp)
            }
            // Fallback: Jika user.xp masih 0, hitung dari akumulasi kebiasaan yang berstatus selesai
            let allHabits = loadHabits()
            let completedXP = allHabits.filter { $0.isCompleted }.reduce(0) { $0 + Int($1.xpReward > 0 ? $1.xpReward : 100) }
            if completedXP > 0 {
                user.xp = Int64(completedXP)
                try? viewContext.save()
                return completedXP
            }
            return 0
        } else {
            let allHabits = loadHabits()
            return allHabits.filter { $0.isCompleted }.reduce(0) { $0 + Int($1.xpReward > 0 ? $1.xpReward : 100) }
        }
    }
    
    func calculateTodayXP() -> Int {
        let allHabits = loadHabits()
        return allHabits.filter { $0.isCompleted }.reduce(0) { $0 + Int($1.xpReward > 0 ? $1.xpReward : 100) }
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
