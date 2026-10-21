//
//  ChallengesPage.swift
//  Levelio
//
//  Created by Irene Ancilla Chow on 30/05/26.
//

import SwiftUI

struct ChallengesPage: View {
    var user: UserEntity? = nil
    @ObservedObject var store: HabitStore = HomePage.sharedHabitStore
    var habitService: HabitService = HomePage.sharedHabitService
    
    private var todayKey: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    
    private var completedCount: Int {
        store.habits.filter { $0.isCompleted }.count
    }
    
    private var totalHabits: Int {
        store.habits.count
    }
    
    private var daysRemainingInWeek: Int {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: Date())
        // iOS: Sunday is 1, Saturday is 7
        return max(1, 8 - weekday)
    }
    
    // IDs for challenges
    private var marathonId: String { "marathon_weekly" }
    private var dailyHabitsId: String { "daily_3_\(todayKey)" }
    private var streakId: String { "streak_3_\(todayKey)" }
    private var allClearedId: String { "all_cleared_\(todayKey)" }
    
    // Target metrics
    private var targetDailyHabits: Int {
        max(1, min(3, totalHabits))
    }
    
    private var isMarathonCompleted: Bool { completedCount >= 15 }
    private var isDailyHabitsCompleted: Bool { completedCount >= targetDailyHabits }
    private var isStreakCompleted: Bool { store.currentStreak >= 3 }
    private var isAllClearedCompleted: Bool { totalHabits > 0 && completedCount >= totalHabits }
    
    var body: some View {
        ZStack {
            // Latar Belakang Gelap Khas Levelio
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // --- 1. HEADER AREA ---
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Levelers Challenges")
                            .font(.system(size: 26, weight: .heavy))
                            .foregroundColor(.white)
                        Text("Complete quests and earn XP")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    
                    // Avatar Pet Dinosaurus
                    Image("ava-1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 55, height: 55)
                        .background(Circle().fill(Color.white.opacity(0.1)))
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1))
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)
                .padding(.bottom, 16)
                
                // --- 2. SCROLLABLE QUEST LIST ---
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        // FEATURED QUEST BANNER (Weekly Growth Marathon)
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("\(daysRemainingInWeek) days remaining")
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.8))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(Color.white.opacity(0.15))
                                    .cornerRadius(10)
                                Spacer()
                                
                                if store.isChallengeClaimed(marathonId) {
                                    Text("Claimed")
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundColor(.cyan)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 4)
                                        .background(Color.cyan.opacity(0.2))
                                        .cornerRadius(10)
                                }
                            }
                            
                            Text("Growth Marathon")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Complete 15 habits to help your pet gain +500 XP")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                                .padding(.bottom, 8)
                            
                            // Progress Pill Bar / Claim Action
                            if isMarathonCompleted && !store.isChallengeClaimed(marathonId) {
                                Button(action: {
                                    store.claimChallengeReward(amount: 500, challengeId: marathonId, for: user)
                                }) {
                                    HStack {
                                        Text("CLAIM REWARD")
                                            .font(.system(size: 13, weight: .heavy))
                                            .foregroundColor(.white)
                                        Spacer()
                                        Text("+500 XP 🎉")
                                            .font(.system(size: 14, weight: .black))
                                            .foregroundColor(.white)
                                    }
                                    .padding(.horizontal, 16)
                                    .frame(height: 44)
                                    .background(
                                        LinearGradient(
                                            colors: [Color("secondary"), Color.cyan],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .cornerRadius(22)
                                    .shadow(color: Color.cyan.opacity(0.5), radius: 10, x: 0, y: 4)
                                }
                            } else {
                                HStack {
                                    Text("+500XP")
                                        .font(.system(size: 14, weight: .black))
                                        .foregroundColor(store.isChallengeClaimed(marathonId) ? .gray : .cyan)
                                        .strikethrough(store.isChallengeClaimed(marathonId))
                                    Spacer()
                                    Text("\(min(completedCount, 15))/15")
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundColor(.white.opacity(0.6))
                                }
                                .padding(.horizontal, 16)
                                .frame(height: 38)
                                .background(Color.black.opacity(0.25))
                                .cornerRadius(19)
                            }
                        }
                        .padding(.all, 20)
                        .background(
                            LinearGradient(
                                colors: [Color(red: 0.15, green: 0.16, blue: 0.38), Color(red: 0.12, green: 0.22, blue: 0.35)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(16)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.1), lineWidth: 1))
                        
                        // SECTION: DAILY CHALLENGES
                        VStack(alignment: .leading, spacing: 14) {
                            Text("Daily Challenges")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                            
                            // Quest 1: Complete 3 habits today
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(alignment: .center, spacing: 14) {
                                    Image(systemName: isDailyHabitsCompleted ? "checkmark.circle.fill" : "circle")
                                        .font(.system(size: 24))
                                        .foregroundColor(isDailyHabitsCompleted ? Color.cyan : .white.opacity(0.8))
                                        .frame(width: 40, height: 40)
                                        .background(Color.white.opacity(0.1))
                                        .cornerRadius(10)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Complete \(targetDailyHabits) habits today")
                                            .font(.system(size: 15, weight: .bold))
                                            .foregroundColor(.white)
                                        Text("+50XP")
                                            .font(.system(size: 14, weight: .black))
                                            .foregroundColor(store.isChallengeClaimed(dailyHabitsId) ? .gray : .cyan)
                                            .strikethrough(store.isChallengeClaimed(dailyHabitsId))
                                    }
                                    
                                    Spacer()
                                    
                                    if isDailyHabitsCompleted && !store.isChallengeClaimed(dailyHabitsId) {
                                        Button(action: {
                                            store.claimChallengeReward(amount: 50, challengeId: dailyHabitsId, for: user)
                                        }) {
                                            Text("Claim")
                                                .font(.system(size: 12, weight: .bold))
                                                .foregroundColor(.white)
                                                .padding(.horizontal, 14)
                                                .padding(.vertical, 8)
                                                .background(Color.cyan)
                                                .cornerRadius(14)
                                        }
                                        .frame(minWidth: 44, minHeight: 44)
                                    } else if store.isChallengeClaimed(dailyHabitsId) {
                                        Text("Done")
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(.gray)
                                    }
                                }
                                
                                HStack {
                                    Text("Progress")
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(.gray)
                                    Spacer()
                                    Text("\(min(completedCount, targetDailyHabits)) / \(targetDailyHabits)")
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundColor(.white)
                                }
                                
                                GeometryReader { geo in
                                    ZStack(alignment: .leading) {
                                        Capsule()
                                            .fill(Color.white.opacity(0.1))
                                            .frame(height: 6)
                                        Capsule()
                                            .fill(LinearGradient(colors: [Color.purple, Color.cyan], startPoint: .leading, endPoint: .trailing))
                                            .frame(
                                                width: max(0, min(geo.size.width, geo.size.width * CGFloat(Double(min(completedCount, targetDailyHabits)) / Double(targetDailyHabits)))),
                                                height: 6
                                            )
                                    }
                                }
                                .frame(height: 6)
                            }
                            .padding(.all, 16)
                            .background(Color.white.opacity(0.04))
                            .cornerRadius(14)
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.08), lineWidth: 1))
                            
                            // Grid Baris Dua (3-day streak & All Habits Cleared)
                            HStack(spacing: 14) {
                                // Mini Card 1: Streak Challenge
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Image(systemName: "flame.fill")
                                            .font(.system(size: 16))
                                            .foregroundColor(isStreakCompleted ? .orange : .white.opacity(0.8))
                                            .frame(width: 32, height: 32)
                                            .background(Color.white.opacity(0.1))
                                            .cornerRadius(8)
                                        Spacer()
                                        if isStreakCompleted && !store.isChallengeClaimed(streakId) {
                                            Button("Claim") {
                                                store.claimChallengeReward(amount: 100, challengeId: streakId, for: user)
                                            }
                                            .font(.system(size: 11, weight: .bold))
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Color.cyan)
                                            .cornerRadius(10)
                                            .frame(minHeight: 44)
                                        }
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("3-day streak")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(.white)
                                        Text("+100XP")
                                            .font(.system(size: 13, weight: .black))
                                            .foregroundColor(store.isChallengeClaimed(streakId) ? .gray : .cyan)
                                            .strikethrough(store.isChallengeClaimed(streakId))
                                    }
                                    
                                    // Segmented Mini Progress Tracker (3 segments)
                                    HStack(spacing: 4) {
                                        Capsule()
                                            .fill(store.currentStreak >= 1 ? Color.purple : Color.white.opacity(0.1))
                                            .frame(height: 4)
                                        Capsule()
                                            .fill(store.currentStreak >= 2 ? Color.purple : Color.white.opacity(0.1))
                                            .frame(height: 4)
                                        Capsule()
                                            .fill(store.currentStreak >= 3 ? Color.purple : Color.white.opacity(0.1))
                                            .frame(height: 4)
                                    }
                                }
                                .padding(.all, 14)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white.opacity(0.04))
                                .cornerRadius(14)
                                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.08), lineWidth: 1))
                                
                                // Mini Card 2: All Habits Cleared
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Image(systemName: "checklist")
                                            .font(.system(size: 16))
                                            .foregroundColor(isAllClearedCompleted ? Color.cyan : .white.opacity(0.8))
                                            .frame(width: 32, height: 32)
                                            .background(Color.white.opacity(0.1))
                                            .cornerRadius(8)
                                        Spacer()
                                        if isAllClearedCompleted && !store.isChallengeClaimed(allClearedId) {
                                            Button("Claim") {
                                                store.claimChallengeReward(amount: 75, challengeId: allClearedId, for: user)
                                            }
                                            .font(.system(size: 11, weight: .bold))
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Color.cyan)
                                            .cornerRadius(10)
                                            .frame(minHeight: 44)
                                        }
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("All Habits")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(.white)
                                        Text("+75XP")
                                            .font(.system(size: 13, weight: .black))
                                            .foregroundColor(store.isChallengeClaimed(allClearedId) ? .gray : .cyan)
                                            .strikethrough(store.isChallengeClaimed(allClearedId))
                                    }
                                    
                                    // Custom Linear Progress
                                    let ratio = totalHabits > 0 ? Double(completedCount) / Double(totalHabits) : 0.0
                                    GeometryReader { geo in
                                        ZStack(alignment: .leading) {
                                            Capsule().fill(Color.white.opacity(0.1)).frame(height: 4)
                                            Capsule()
                                                .fill(LinearGradient(colors: [Color.purple, Color.cyan], startPoint: .leading, endPoint: .trailing))
                                                .frame(width: max(0, min(geo.size.width, geo.size.width * CGFloat(ratio))), height: 4)
                                        }
                                    }
                                    .frame(height: 4)
                                }
                                .padding(.all, 14)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white.opacity(0.04))
                                .cornerRadius(14)
                                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.08), lineWidth: 1))
                            }
                        }
                        
                        // SECTION: PAST CHALLENGES
                        VStack(alignment: .leading, spacing: 14) {
                            Text("Past Challenges")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                            
                            if store.claimedChallengeIds.isEmpty {
                                HStack {
                                    Spacer()
                                    VStack(spacing: 8) {
                                        Image(systemName: "trophy")
                                            .font(.system(size: 24))
                                            .foregroundColor(.gray.opacity(0.5))
                                        Text("No completed challenges yet")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(.gray)
                                        Text("Complete quests above to record your achievements here")
                                            .font(.system(size: 12))
                                            .foregroundColor(.gray.opacity(0.7))
                                            .multilineTextAlignment(.center)
                                    }
                                    .padding(.vertical, 24)
                                    .padding(.horizontal, 16)
                                    Spacer()
                                }
                                .background(Color.white.opacity(0.02))
                                .cornerRadius(16)
                                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.04), lineWidth: 1))
                            } else {
                                if store.isChallengeClaimed(marathonId) {
                                    PastChallengeCard(
                                        title: "Growth Marathon",
                                        subtitle: "Completed 15 habits and claimed pet reward",
                                        xpText: "+500XP",
                                        progressText: "15/15"
                                    )
                                }
                                
                                if store.isChallengeClaimed(dailyHabitsId) {
                                    PastChallengeCard(
                                        title: "Daily Habits Champion",
                                        subtitle: "Completed target habits today",
                                        xpText: "+50XP",
                                        progressText: "\(targetDailyHabits)/\(targetDailyHabits)"
                                    )
                                }
                                
                                if store.isChallengeClaimed(streakId) {
                                    PastChallengeCard(
                                        title: "3-Day Streak Achieved",
                                        subtitle: "Consistent habit tracking",
                                        xpText: "+100XP",
                                        progressText: "3/3"
                                    )
                                }
                                
                                if store.isChallengeClaimed(allClearedId) {
                                    PastChallengeCard(
                                        title: "All Habits Cleared",
                                        subtitle: "100% daily completion rate",
                                        xpText: "+75XP",
                                        progressText: "Done"
                                    )
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 10)
                    .padding(.bottom, 24)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct PastChallengeCard: View {
    let title: String
    let subtitle: String
    let xpText: String
    let progressText: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 4) {
                    Text("Completed")
                    Image(systemName: "checkmark.circle.fill")
                }
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.cyan)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color.cyan.opacity(0.15))
                .cornerRadius(10)
                Spacer()
            }
            
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white.opacity(0.7))
            
            Text(subtitle)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white.opacity(0.4))
                .padding(.bottom, 4)
            
            HStack {
                Text(xpText)
                    .font(.system(size: 13, weight: .black))
                    .foregroundColor(.gray)
                    .strikethrough()
                Spacer()
                Text(progressText)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.white.opacity(0.4))
            }
            .padding(.horizontal, 16)
            .frame(height: 32)
            .background(Color.black.opacity(0.15))
            .cornerRadius(16)
        }
        .padding(.all, 16)
        .background(Color.white.opacity(0.02))
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.04), lineWidth: 1))
    }
}

#Preview {
    ChallengesPage()
}
