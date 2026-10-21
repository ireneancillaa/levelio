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
    @Published var totalXP: Int = 0
    @Published var todayXP: Int = 0
    @Published var currentStreak: Int = 0
    @Published var bestStreak: Int = 0
    @Published var claimedChallengeIds: Set<String> = []
    
    private var claimedStorageKey: String {
        let userId = UserDefaults.standard.string(forKey: "currentUserId") ?? "default"
        return "levelio_claimed_challenges_\(userId)"
    }
    
    // MARK: - Initialization
    init() {
        self.habitService = .shared
        loadClaimedChallenges()
        loadHabits()
    }

    init(context: NSManagedObjectContext) {
        self.habitService = HabitService(context: context)
        loadClaimedChallenges()
        loadHabits()
    }
    
    func loadClaimedChallenges() {
        if let array = UserDefaults.standard.stringArray(forKey: claimedStorageKey) {
            claimedChallengeIds = Set(array)
        } else {
            claimedChallengeIds = []
        }
    }
    
    private func saveClaimedChallenges() {
        UserDefaults.standard.set(Array(claimedChallengeIds), forKey: claimedStorageKey)
    }
    
    // MARK: - Actions
    func addHabit(title: String, description: String, colorName: String = "primary", frequency: String = "Daily", time: String = "08.00am", user: UserEntity? = nil) {
        do {
            let _ = try habitService.addHabit(
                title: title,
                description: description,
                colorName: colorName,
                frequency: frequency,
                time: time
            )
            loadHabits(for: user)
        } catch {
            print("Failed to add habit: \(error.localizedDescription)")
        }
    }
    
    func toggleCompletion(for habitID: UUID, user: UserEntity? = nil) {
        do {
            try habitService.toggleCompletion(for: habitID)
            loadHabits(for: user)
        } catch {
            print("Failed to toggle habit: \(error.localizedDescription)")
        }
    }
    
    func deleteHabit(id: UUID, user: UserEntity? = nil) {
        do {
            try habitService.deleteHabit(id: id)
            loadHabits(for: user)
        } catch {
            print("Failed to delete habit: \(error.localizedDescription)")
        }
    }
    
    func resetAllHabits(for user: UserEntity? = nil) {
        do {
            try habitService.resetAllHabitsCompletion(for: user)
            loadHabits(for: user)
        } catch {
            print("Failed to reset habits: \(error.localizedDescription)")
        }
    }
    
    func claimChallengeReward(amount: Int, challengeId: String, for user: UserEntity?) {
        guard !claimedChallengeIds.contains(challengeId) else { return }
        guard let user = user else { return }
        do {
            try habitService.addBonusXP(amount: Int64(amount), for: user)
            claimedChallengeIds.insert(challengeId)
            saveClaimedChallenges()
            loadHabits(for: user)
        } catch {
            print("Failed to claim bonus XP: \(error.localizedDescription)")
        }
    }
    
    func isChallengeClaimed(_ id: String) -> Bool {
        claimedChallengeIds.contains(id)
    }
    
    func refresh(for user: UserEntity? = nil) {
        loadClaimedChallenges()
        loadHabits(for: user)
    }
    
    func getActiveDaysInMonth(for date: Date, user: UserEntity? = nil) -> Set<Int> {
        habitService.getActiveDaysInMonth(for: date, user: user)
    }
    
    // MARK: - Private
    private func loadHabits(for user: UserEntity? = nil) {
        habits = habitService.loadHabits()
        totalXP = habitService.calculateTotalXP(for: user)
        todayXP = habitService.calculateTodayXP()
        currentStreak = habitService.calculateCurrentStreak(for: user)
        bestStreak = habitService.getBestStreak(for: user)
    }
}
