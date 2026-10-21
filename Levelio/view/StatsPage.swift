//
//  StatsPage.swift
//  Levelio
//
//  Created by Irene Ancilla Chow on 30/05/26.
//

import SwiftUI

struct StatsPage: View {
    var user: UserEntity? = nil
    @ObservedObject var store: HabitStore = HomePage.sharedHabitStore
    var habitService: HabitService = HomePage.sharedHabitService
    
    private var isCompactScreen: Bool {
        UIScreen.isCompact
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            // --- AREA 1: STATIS (Header Terkunci di Atas Layar) ---
            StatsHeaderView()
                .padding(.horizontal, 24)
                .padding(.top, 8)
                .padding(.bottom, isCompactScreen ? 8 : 16)
            
            // --- AREA 2: SCROLLABLE (Mulai dari Streak Banner ke Bawah) ---
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: isCompactScreen ? 16 : 20) {
                    
                    // Banner Utama: Papan Target Panahan
                    StreakCardView(user: user, currentStreak: store.currentStreak)
                    
                    // Dua Kartu Kembar: Best Streak & Completion
                    TwinMetricsGrid(
                        bestStreak: store.bestStreak,
                        completionRate: habitService.calculateCompletionPercentage()
                    )
                    
                    // Section Kalender: Consistency Tracker
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Consistency")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                        
                        ConsistencyCalendarView(habitService: habitService, user: user)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 5)
                .padding(.bottom, 24)
            }
        }
        .background(
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        )
    }
}

// MARK: - 1. STATS HEADER VIEW (Identik dengan Susunan Home)
struct StatsHeaderView: View {
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Levelers Analytics")
                    .font(.system(size: 26, weight: .heavy))
                    .foregroundColor(.white)
                
                Text("Keep the streak going!")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Avatar Dino Lingkaran Berwarna Hijau
            Image("ava-1")
                .resizable()
                .scaledToFit()
                .frame(width: 55, height: 55)
                .background(Circle().fill(Color.white.opacity(0.1)))
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1))
        }
    }
}

// MARK: - 2. STREAK TARGET BANNER
struct StreakCardView: View {
    var user: UserEntity?
    var currentStreak: Int = 0
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) { // Mengunci semua elemen overlay ke pojok kanan bawah
            
            // Konten Utama Card (Teks di kiri, ruang kosong di kanan)
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Streak")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text("\(currentStreak) \(currentStreak == 1 ? "Day" : "Days")")
                        .font(.system(size: 28, weight: .black))
                        .foregroundColor(Color("primary"))
                        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: currentStreak)
                    
                    Text(currentStreak > 0 ? "You're on a roll!" : "Start your streak today")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.gray)
                }
                
                Spacer() // Mendorong teks tetap konsisten di kiri
                
                // Kotak transparan penahan ruang kanan agar tidak menabrak teks
                Color.clear
                    .frame(width: 100, height: 100)
            }
            .padding(.all, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Gambar Dart Target yang otomatis nempel di kanan bawah dan ter-crop melengkung
            Image("dart")
                .resizable()
                .scaledToFit()
                .frame(width: 130, height: 130)
                .offset(x: 0, y: 15)
            
        }
        .background(
            ZStack {
                Color("primary").opacity(0.04)
            }
        )
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                        colors: [.white.opacity(0.18), .white.opacity(0.02)],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .clipped()
    }
}

// MARK: - 3. TWIN METRICS GRID (KARTU KEMBAR)
struct TwinMetricsGrid: View {
    var bestStreak: Int = 0
    var completionRate: Int = 0
    
    var body: some View {
        HStack(spacing: 16) {
            
            // Kartu Kiri: Best Streak
            VStack(alignment: .leading, spacing: 14) {
                Image(systemName: "medal.star")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(width: 45, height: 45)
                    .background(Circle().fill(Color.white.opacity(0.08)))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Best Streak")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.gray)
                    
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("\(bestStreak)")
                            .font(.system(size: 26, weight: .black))
                            .foregroundColor(Color("primary"))
                            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: bestStreak)
                        Text(bestStreak == 1 ? "Day" : "Days")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.all, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                ZStack {
                    Color.white.opacity(0.04)
                }
            )
            .cornerRadius(16)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(LinearGradient(colors: [.white.opacity(0.15), .clear], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1))
            
            // Kartu Kanan: Completion Rate
            VStack(alignment: .leading, spacing: 14) {
                Image(systemName: "chart.pie")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(width: 45, height: 45)
                    .background(Circle().fill(Color.white.opacity(0.08)))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Completion")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.gray)
                    
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("\(completionRate)")
                            .font(.system(size: 26, weight: .black))
                            .foregroundColor(Color("secondary"))
                            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: completionRate)
                        Text("%")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.all, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                ZStack {
                    Color.white.opacity(0.04)
                }
            )
            .cornerRadius(16)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(LinearGradient(colors: [.white.opacity(0.15), .clear], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1))
        }
    }
}

// MARK: - 4. CONSISTENCY CALENDAR VIEW (DINAMIS & OTOMATIS)
struct ConsistencyCalendarView: View {
    var habitService: HabitService = HomePage.sharedHabitService
    var user: UserEntity? = nil
    
    @State private var currentMonthDate = Date()
    
    private var activeDays: Set<Int> {
        habitService.getActiveDaysInMonth(for: currentMonthDate, user: user)
    }
    
    let daysOfWeek = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    
    var body: some View {
        VStack(spacing: 20) {
            // Header Kalender: Nama Bulan & Tahun Riil beserta Tombol Navigasi
            HStack {
                Text(formatMonthYear(currentMonthDate))
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                HStack(spacing: 8) {
                    Button(action: { changeMonth(by: -1) }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.blue)
                            .frame(width: 44, height: 44)
                            .contentShape(Rectangle())
                    }
                    Button(action: { changeMonth(by: 1) }) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.blue)
                            .frame(width: 44, height: 44)
                            .contentShape(Rectangle())
                    }
                }
            }
            .padding(.horizontal, 4)
            
            // Grid Lini Nama Hari (SUN - SAT)
            HStack(spacing: 0) {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.gray.opacity(0.7))
                        .frame(maxWidth: .infinity)
                }
            }
            
            // Grid Sel Tanggal Dinamis (7 Kolom Seminggu)
            let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
            let daysInMonth = getDaysInMonth()
            let firstDayOffset = getFirstDayOfWeekOffset()
            let totalSlots = daysInMonth + firstDayOffset
            
            LazyVGrid(columns: columns, spacing: 18) {
                ForEach(0..<totalSlots, id: \.self) { index in
                    if index < firstDayOffset {
                        Text("")
                            .frame(height: 34)
                    } else {
                        let dateNumber = index - firstDayOffset + 1
                        let isToday = checkIsToday(dateNumber: dateNumber)
                        let isActive = activeDays.contains(dateNumber)
                        
                        Text("\(dateNumber)")
                            .font(.system(size: 15, weight: isToday || isActive ? .bold : .semibold))
                            .foregroundColor(isToday || isActive ? .white : .white.opacity(0.8))
                            .frame(width: 34, height: 34)
                            .background(
                                Group {
                                    if isToday && isActive {
                                        Circle().fill(Color("primary").opacity(0.35))
                                    } else if isActive {
                                        Circle().fill(Color("secondary").opacity(0.25))
                                    } else if isToday {
                                        Circle().fill(Color.blue.opacity(0.2))
                                    }
                                }
                            )
                            .overlay(
                                Group {
                                    if isToday && isActive {
                                        Circle().stroke(Color("primary"), lineWidth: 1.5)
                                    } else if isActive {
                                        Circle().stroke(Color("secondary").opacity(0.8), lineWidth: 1)
                                    } else if isToday {
                                        Circle().stroke(Color.blue, lineWidth: 1)
                                    }
                                }
                            )
                    }
                }
            }
        }
        .padding(.all, 20)
        .background(
            ZStack {
                Color.white.opacity(0.04)
            }
        )
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                        colors: [.white.opacity(0.04), .clear],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
    }
    
    // MARK: - LOGIKA PENANGGALAN OTOMATIS
    
    private func formatMonthYear(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
    
    private func getDaysInMonth() -> Int {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: currentMonthDate)!
        return range.count
    }
    
    private func getFirstDayOfWeekOffset() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: currentMonthDate)
        let firstDayOfMonth = calendar.date(from: components)!
        return calendar.component(.weekday, from: firstDayOfMonth) - 1
    }
    
    private func checkIsToday(dateNumber: Int) -> Bool {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month], from: currentMonthDate)
        components.day = dateNumber
        
        guard let targetDate = calendar.date(from: components) else { return false }
        return calendar.isDateInToday(targetDate)
    }
    
    private func changeMonth(by value: Int) {
        let calendar = Calendar.current
        if let newDate = calendar.date(byAdding: .month, value: value, to: currentMonthDate) {
            currentMonthDate = newDate
        }
    }
}

#Preview {
    StatsPage()
}
