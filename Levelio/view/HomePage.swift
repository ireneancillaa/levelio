//
//  HomePage.swift
//  Levelio
//
//  Created by Irene Ancilla Chow on 30/05/26.
//

import SwiftUI

struct HomePage: View {
    @State private var selectedTab = 0
    
    // 1. Saklar state untuk mengontrol buka/tutup lembaran AddPage
    @State private var isPresentingAddPage = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            // --- TAB 0: HOME ---
            HomeTabContent()
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
                AddPage()
            }
        }
    }
}

// MARK: - KONTEN UTAMA HALAMAN HOME
struct HomeTabContent: View {
    var body: some View {
        ZStack {
            // Latar Belakang Gelap Khas Levelio
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            // Menggunakan VStack utama untuk memisahkan area Statis (Atas) dan area Scrollable (Bawah)
            VStack(spacing: 0) {
                
                // --- AREA 1: STATIS (Mengunci di atas, tidak ikut bergeser) ---
                VStack(alignment: .leading, spacing: 25) {
                    HeaderView()
                        .padding(.top, 50) // Disesuaikan agar pas di bawah status bar bersama safeAreaPadding
                    
                    EggHeroSection()
                    
                    EvolutionJourneyTimeline()
                    
                    XpProgressCard()
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 20) // Memberi jarak sebelum masuk ke batas awal ScrollView
                
                // --- AREA 2: SCROLLABLE (Hanya bagian progress ke bawah) ---
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 25) {
                        
                        HabitSectionView(title: "Today's Progress", status: .active)
                        
                        HabitSectionView(title: "Past Progress", status: .completed)
                        
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
                    .font(.system(size: 24, weight: .heavy))
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
                    .frame(height: 180)
                    .shadow(color: Color.blue.opacity(0.3), radius: 20, x: 0, y: 10)
                
                // Balon Komik Dialog "Hatch me!"
                Image("speech-bubble") // Atur asset balon teks Anda
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80)
                    .offset(x: 60, y: -25)
            }
            Spacer()
        }
        .padding(.vertical, 10)
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
        VStack(spacing: 8) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .opacity(isActive ? 1.0 : 0.3) // Meredup jika belum tercapai
            
            Text(label)
                .font(.system(size: 8, weight: .heavy))
                .foregroundColor(isActive ? .white : .gray)
        }
        .frame(maxWidth: .infinity)
    }
}

struct TimelineLine: View {
    var body: some View {
        Rectangle()
            .fill(Color.white.opacity(0.2))
            .frame(height: 1)
            .frame(maxWidth: .infinity)
            .offset(y: -10) // Menyelaraskan garis horizontal di tengah ikon
    }
}

// MARK: - 4. XP PROGRESS CARD
struct XpProgressCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Egg")
                    .font(.system(size: 14, weight: .heavy))
                Spacer()
                Text("150/400 XP")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.gray)
            }
            .foregroundColor(.white)
            
            // Custom Linear Progress Bar (Ungu Gradasi Putih)
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.white)
                        .frame(height: 6)
                    
                    Capsule()
                        .fill(LinearGradient(colors: [Color("secondary"), Color("secondary").opacity(0.6)], startPoint: .leading, endPoint: .trailing))
                        // Mengkalkulasi porsi bar terisi (150 dari 400 XP)
                        .frame(width: geo.size.width * (150/400), height: 6)
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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            // Menampilkan dua baris habit tiruan per section sesuai contoh gambar
            HabitRowCard(habitName: "Morning Yoga", time: "08.00am", status: status)
            HabitRowCard(habitName: "Morning Yoga", time: "08.00am", status: status)
        }
    }
}

struct HabitRowCard: View {
    let habitName: String
    let time: String
    let status: HabitStatus
    
    var body: some View {
        HStack(spacing: 16) {
            // Indikator Titik Berwarna Lingkaran (Ungu vs Cyan)
            Circle()
                .fill(status == .active ? Color("secondary").opacity(0.8) : Color("primary").opacity(0.8))
                .frame(width: 20, height: 20)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(habitName)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                Text(time)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Info XP & Status Centang Kanan
            if status == .active {
                Text("+50XP")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color("secondary").opacity(0.9))
                
                Image(systemName: "circle")
                    .font(.system(size: 18))
                    .foregroundColor(.gray.opacity(0.5))
            } else {
                VStack(alignment: .trailing, spacing: 2) {
                    Text("+50XP")
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
}

#Preview {
    HomePage()
}
