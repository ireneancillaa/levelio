//
//  HomePage.swift
//  Levelio
//
//  Created by Irene Ancilla Chow on 30/05/26.
//

import SwiftUI

struct HomePage: View {
    @StateObject private var habitStore = HabitStore()
    @State private var selectedTab = 0
    
    // 1. Saklar state untuk mengontrol buka/tutup lembaran AddPage
    @State private var isPresentingAddPage = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            // --- TAB 0: HOME ---
            HomeTabContent(store: habitStore)
                .tabItem {
                    Label("Home", systemImage: selectedTab == 0 ? "house.fill" : "house")
                }
                .tag(0)
            
            // --- TAB 1: STATS ---
            StatsPage()
                .tabItem {
                    Label("Stats", systemImage: selectedTab == 1 ? "chart.bar.fill" : "chart.bar")
                }
                .tag(1)
            
            // --- TAB 2: ADD (Menggunakan halaman kosong transparan sebagai pemicu) ---
            Color.clear
                .tabItem {
                    Label("Add", systemImage: "plus.circle.fill")
                }
                .tag(2)
            
            // --- TAB 3: CHALLENGES ---
            ChallengesPage()
                .tabItem {
                    Label("Challenges", systemImage: selectedTab == 3 ? "trophy.fill" : "trophy")
                }
                .tag(3)
            
            // --- TAB 4: PROFILE ---
            ProfilePage()
                .tabItem {
                    Label("Profile", systemImage: selectedTab == 4 ? "person.fill" : "person")
                }
                .tag(4)
        }
        .tint(.blue)
        .preferredColorScheme(.dark)
        
        // 2. DETEKSI AMAN: Begitu user mengetuk Tab ke-2 (Plus), langsung cegah masuk ke layar kosong
        .onChange(of: selectedTab) { oldValue, newValue in
            if newValue == 2 {
                // Kembalikan seleksi tab aktif ke halaman sebelumnya agar tidak macet di layar kosong
                selectedTab = oldValue
                
                // Nyalakan lembaran penuh AddPage
                isPresentingAddPage = true
            }
        }
        
        // 3. KUNCI UTAMA: Memanggil AddPage dengan pembungkus NavigationStack dari luar
        .fullScreenCover(isPresented: $isPresentingAddPage) {
            NavigationStack {
                AddPage(store: habitStore)
            }
        }
    }
}

// MARK: - KONTEN UTAMA HALAMAN HOME
struct HomeTabContent: View {
    @ObservedObject var store: HabitStore
    
    var body: some View {
        ZStack {
            // Latar Belakang Gelap Khas Levelio
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            // Menggunakan VStack utama untuk memisahkan area Statis (Atas) dan area Scrollable (Bawah)
            VStack(spacing: 0) {
                
                // --- AREA 1: HEADER STATIS (Identik dengan Stats & Challenges) ---
                HeaderView()
                    .padding(.horizontal, 24)
                    .padding(.top, 50)
                    .padding(.bottom, 20)
                
                // --- AREA 2: HERO, TIMELINE, XP CARD ---
                VStack(alignment: .leading, spacing: 25) {
                    EggHeroSection()
                    
                    EvolutionJourneyTimeline()
                    
                    XpProgressCard()
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 20) // Memberi jarak sebelum masuk ke batas awal ScrollView
                
                // --- AREA 2: SCROLLABLE (Hanya bagian progress ke bawah) ---
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 25) {
                        
                        HabitSectionView(
                            title: "Today's Progress",
                            status: .active,
                            habits: store.habits.filter { !$0.isCompleted },
                            onToggle: { habit in
                                store.toggleCompletion(for: habit.id)
                            }
                        )
                        
                        HabitSectionView(
                            title: "Past Progress",
                            status: .completed,
                            habits: store.habits.filter { $0.isCompleted },
                            onToggle: { habit in
                                store.toggleCompletion(for: habit.id)
                            }
                        )
                        
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 5) // Padding tipis agar bayangan card teratas tidak terpotong kaku
                    .padding(.bottom, 90)
                }
            }
            .safeAreaPadding(.top) // Otomatis menjaga tumpukan atas menghormati Dynamic Island/Notch iPhone
        }
    }
}

// MARK: - 1. HEADER VIEW
struct HeaderView: View {
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Morning, Samsudin!")
                    .font(.system(size: 26, weight: .heavy))
                    .foregroundColor(.white)
                
                Text("Monday, 20 April 2026")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Avatar Dino Lingkaran Berwarna Hijau
            Image("ava-1") // Pastikan asset disiapkan di Assets catalog
                .resizable()
                .scaledToFit()
                .frame(width: 55, height: 55)
                .background(Circle().fill(Color.white.opacity(0.1)))
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1))
        }
    }
}

// MARK: - 2. EGG HERO SECTION
struct EggHeroSection: View {
    var body: some View {
        HStack {
            Spacer()
            ZStack(alignment: .topTrailing) {
                // Gambar Telur Utama Berpendar (Glow)
                Image("dino-egg-blue")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 160)
                    .shadow(color: Color.blue.opacity(0.3), radius: 20, x: 0, y: 10)
                
                // Balon Komik Dialog "Hatch me!"
                Image("speech-bubble") // Atur asset balon teks Anda
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70)
                    .offset(x: 50, y: -20)
            }
            Spacer()
        }
        .padding(.vertical, 6)
    }
}

// MARK: - 3. EVOLUTION JOURNEY TIMELINE
struct EvolutionJourneyTimeline: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Udin’s Evolution Journey")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            HStack(spacing: 0) {
                TimelineNode(imageName: "dino-egg-blue", label: "Egg", isActive: true)
                TimelineLine()
                TimelineNode(imageName: "dino-hatch-blue", label: "Hatchling", isActive: false)
                TimelineLine()
                TimelineNode(imageName: "dino-baby-blue", label: "Baby Dino", isActive: false)
                TimelineLine()
                TimelineNode(imageName: "dino-adult-blue", label: "Adult Dino", isActive: false)
            }
        }
    }
}

struct TimelineNode: View {
    let imageName: String
    let label: String
    let isActive: Bool
    
    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(isActive ? Color.white.opacity(0.15) : Color.white.opacity(0.04))
                    .frame(width: 44, height: 44)
                    .overlay(
                        Circle()
                            .stroke(isActive ? Color("secondary") : Color.white.opacity(0.1), lineWidth: isActive ? 2 : 1)
                    )
                
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 26, height: 26)
                    .opacity(isActive ? 1.0 : 0.4)
            }
            
            Text(label)
                .font(.system(size: 10, weight: isActive ? .bold : .medium))
                .foregroundColor(isActive ? .white : .gray)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity)
    }
}

struct TimelineLine: View {
    var body: some View {
        Rectangle()
            .fill(Color.white.opacity(0.15))
            .frame(height: 2)
            .offset(y: -10)
    }
}

// MARK: - 4. XP PROGRESS CARD
struct XpProgressCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Label Level Saat Ini & XP Numeric Indicator
            HStack {
                Text("Level 1: Egg")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("150 / 400 XP")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color("secondary"))
            }
            
            // Custom Linear Progress Bar Capsul
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 6)
                    
                    Capsule()
                        .fill(LinearGradient(colors: [Color("secondary"), Color("secondary").opacity(0.6)], startPoint: .leading, endPoint: .trailing))
                        .frame(width: geo.size.width * (150.0 / 400.0), height: 6)
                }
            }
            .frame(height: 6)
            
            // Keterangan Sisa Angka XP Menuju Evolusi Selanjutnya
            HStack(spacing: 4) {
                Image(systemName: "megaphone.fill")
                    .font(.system(size: 11))
                Text("250 XP left to hatch into")
                Text("Hatchling")
                    .fontWeight(.bold)
                    .foregroundColor(Color("primary"))
            }
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(.gray)
        }
        .padding(.all, 16)
        .background(Color.white.opacity(0.04))
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
    }
}

// MARK: - 5. HABIT LIST SECTION (TODAY & PAST)
enum HabitStatus {
    case active, completed
}

struct HabitSectionView: View {
    let title: String
    let status: HabitStatus
    let habits: [Habit]
    let onToggle: (Habit) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text(title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("\(habits.count)")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.gray)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(8)
            }
            
            if habits.isEmpty {
                HStack {
                    Spacer()
                    VStack(spacing: 6) {
                        Image(systemName: status == .active ? "sparkles" : "checkmark.seal")
                            .font(.system(size: 22))
                            .foregroundColor(.gray.opacity(0.5))
                        Text(status == .active ? "No active habits right now" : "No completed habits yet")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.gray.opacity(0.6))
                    }
                    .padding(.vertical, 16)
                    Spacer()
                }
                .background(Color.white.opacity(0.02))
                .cornerRadius(14)
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.05), lineWidth: 1))
            } else {
                ForEach(habits) { habit in
                    HabitRowCard(habit: habit, status: status) {
                        onToggle(habit)
                    }
                }
            }
        }
    }
}

struct HabitRowCard: View {
    let habit: Habit
    let status: HabitStatus
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 16) {
                // Indikator Titik Berwarna Lingkaran (Ungu vs Cyan)
                Circle()
                    .fill(status == .active ? Color("secondary").opacity(0.8) : Color("primary").opacity(0.8))
                    .frame(width: 20, height: 20)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(habit.title)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(habit.time)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // Info XP & Status Centang Kanan
                if status == .active {
                    Text("+\(habit.xpReward)XP")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Color("secondary").opacity(0.9))
                    
                    Image(systemName: "circle")
                        .font(.system(size: 18))
                        .foregroundColor(.gray.opacity(0.5))
                } else {
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("+\(habit.xpReward)XP")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.gray.opacity(0.4))
                            .strikethrough() // Efek coret tulisan XP karena sudah diklaim
                        Text("Completed!")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.gray)
                    }
                    
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                }
            }
            .padding(.all, 16)
            .background(Color.white.opacity(0.04))
            .cornerRadius(14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    HomePage()
}
