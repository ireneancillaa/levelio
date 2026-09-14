//
//  ChallengesPage.swift
//  Levelio
//
//  Created by Irene Ancilla Chow on 30/05/26.
//

import SwiftUI

struct ChallengesPage: View {
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
                            .font(.system(size: 28, weight: .black))
                            .foregroundColor(.white)
                        Text("Complete quests and earn XP")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    
                    // Avatar Pet Dinosaurus
                    Image("ava-1") // Sesuaikan dengan nama aset dinal Anda di Xcode
                        .resizable()
                        .scaledToFill()
                        .frame(width: 55, height: 55)
                        .background(Color.white.opacity(0.1))
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white.opacity(0.2), lineWidth: 1))
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
                .padding(.top, 50)
                
                // --- 2. SCROLLABLE QUEST LIST ---
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        // FEATURED QUEST BANNER (Spring Growth Marathon Active)
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("7 days remaining")
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.8))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(Color.white.opacity(0.15))
                                    .cornerRadius(10)
                                Spacer()
                            }
                            
                            Text("Spring Growth Marathon")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Complete 20 habits to help your pet gain +500 XP")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                                .padding(.bottom, 8)
                            
                            // Progress Pill Bar
                            HStack {
                                Text("+500XP")
                                    .font(.system(size: 14, weight: .black))
                                    .foregroundColor(.cyan)
                                Spacer()
                                Text("12/20")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            .padding(.horizontal, 16)
                            .frame(height: 34)
                            .background(Color.black.opacity(0.25))
                            .cornerRadius(17)
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
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(.white.opacity(0.8))
                                        .frame(width: 40, height: 40)
                                        .background(Color.white.opacity(0.1))
                                        .cornerRadius(10)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Complete 3 habits today")
                                            .font(.system(size: 15, weight: .bold))
                                            .foregroundColor(.white)
                                        Text("+50XP")
                                            .font(.system(size: 14, weight: .black))
                                            .foregroundColor(.cyan)
                                    }
                                }
                                
                                HStack {
                                    Text("Progress")
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(.gray)
                                    Spacer()
                                    Text("2 / 3")
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundColor(.white)
                                }
                                
                                // Custom Custom Linear Progress Bar
                                GeometryReader { geo in
                                    ZStack(alignment: .leading) {
                                        Capsule()
                                            .fill(Color.white.opacity(0.1))
                                            .frame(height: 6)
                                        Capsule()
                                            .fill(LinearGradient(colors: [Color.purple, Color.cyan], startPoint: .leading, endPoint: .trailing))
                                            .frame(width: geo.size.width * (2.0 / 3.0), height: 6)
                                    }
                                }
                                .frame(height: 6)
                            }
                            .padding(.all, 16)
                            .background(Color.white.opacity(0.04))
                            .cornerRadius(14)
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.08), lineWidth: 1))
                            
                            // Grid Baris Dua (3-day streak & Drink 2L Water)
                            HStack(spacing: 14) {
                                // Mini Card 1
                                VStack(alignment: .leading, spacing: 12) {
                                    Image(systemName: "chart.line.uptrend.xyaxis")
                                        .font(.system(size: 18))
                                        .foregroundColor(.white.opacity(0.8))
                                        .frame(width: 32, height: 32)
                                        .background(Color.white.opacity(0.1))
                                        .cornerRadius(8)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("3-day streak")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(.white)
                                        Text("+100XP")
                                            .font(.system(size: 13, weight: .black))
                                            .foregroundColor(.cyan)
                                    }
                                    
                                    // Segmented Mini Progress Tracker (2/3 complete)
                                    HStack(spacing: 4) {
                                        Capsule().fill(Color.purple).frame(height: 4)
                                        Capsule().fill(Color.purple).frame(height: 4)
                                        Capsule().fill(Color.white.opacity(0.1)).frame(height: 4)
                                    }
                                }
                                .padding(.all, 14)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white.opacity(0.04))
                                .cornerRadius(14)
                                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.08), lineWidth: 1))
                                
                                // Mini Card 2
                                VStack(alignment: .leading, spacing: 12) {
                                    Image(systemName: "drop.fill")
                                        .font(.system(size: 18))
                                        .foregroundColor(.white.opacity(0.8))
                                        .frame(width: 32, height: 32)
                                        .background(Color.white.opacity(0.1))
                                        .cornerRadius(8)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Drink 2L Water")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(.white)
                                        Text("+75XP")
                                            .font(.system(size: 13, weight: .black))
                                            .foregroundColor(.cyan)
                                    }
                                    
                                    // Custom Linear Progress (70% full)
                                    ZStack(alignment: .leading) {
                                        Capsule().fill(Color.white.opacity(0.1)).frame(height: 4)
                                        Capsule().fill(LinearGradient(colors: [Color.purple, Color.cyan], startPoint: .leading, endPoint: .trailing))
                                            .frame(width: 70, height: 4) // Angka fiktif representasi visual
                                    }
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
                            
                            // Past Card 1 (Completed Spring Marathon)
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    HStack(spacing: 4) {
                                        Text("Completed")
                                        Image(systemName: "checkmark.circle")
                                    }
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(.white.opacity(0.6))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(Color.white.opacity(0.1))
                                    .cornerRadius(10)
                                    Spacer()
                                }
                                
                                Text("Spring Growth Marathon")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.white.opacity(0.6)) // Di-dim karena masa lalu
                                
                                Text("Complete 20 habits to help your pet gain +500 XP")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white.opacity(0.4))
                                    .padding(.bottom, 8)
                                
                                HStack {
                                    Text("+500XP")
                                        .font(.system(size: 14, weight: .black))
                                        .foregroundColor(.gray)
                                        .strikethrough() // Efek coret tulisan XP selesai diklaim
                                    Spacer()
                                    Text("20/20")
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundColor(.white.opacity(0.4))
                                }
                                .padding(.horizontal, 16)
                                .frame(height: 34)
                                .background(Color.black.opacity(0.15))
                                .cornerRadius(17)
                            }
                            .padding(.all, 20)
                            .background(Color.white.opacity(0.02))
                            .cornerRadius(16)
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.04), lineWidth: 1))
                            
                            // Past Card 2 (Complete 5 habits today)
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(alignment: .center, spacing: 14) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(.white.opacity(0.4))
                                        .frame(width: 40, height: 40)
                                        .background(Color.white.opacity(0.05))
                                        .cornerRadius(10)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Complete 5 habits today")
                                            .font(.system(size: 15, weight: .bold))
                                            .foregroundColor(.white.opacity(0.5))
                                        Text("+50XP")
                                            .font(.system(size: 14, weight: .black))
                                            .foregroundColor(.gray)
                                    }
                                }
                                
                                HStack {
                                    Text("Done!")
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(.gray)
                                    Spacer()
                                    Text("5 / 5")
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundColor(.white.opacity(0.5))
                                }
                                
                                Capsule()
                                    .fill(Color.purple.opacity(0.5))
                                    .frame(height: 6)
                            }
                            .padding(.all, 16)
                            .background(Color.white.opacity(0.02))
                            .cornerRadius(14)
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.04), lineWidth: 1))
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 10)
                    .padding(.bottom, 100)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ChallengesPage()
}
