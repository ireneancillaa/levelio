//
//  StatsPage.swift
//  Levelio
//
//  Created by Irene Ancilla Chow on 30/05/26.
//

import SwiftUI

struct StatsPage: View {
    var body: some View {
        ZStack {
            // 1. Latar Belakang Gelap Khas Levelio
            Image("background")
                .resizable()
                .scaledToFill()
                // Mengunci batas safe area atas, menyisakan area bawah bersih untuk Tab Bar asli iOS
                .ignoresSafeArea(.container, edges: .top)
            
            VStack(spacing: 0) {
                
                // --- AREA 1: STATIS (Header Terkunci di Atas Layar) ---
                StatsHeaderView()
                    .padding(.horizontal, 24)
                    .padding(.top, 50)
                    .padding(.bottom, 20)
                
                // --- AREA 2: SCROLLABLE (Mulai dari Streak Banner ke Bawah) ---
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // Banner Utama: Papan Target Panahan
                        StreakCardView()
                        
                        // Dua Kartu Kembar: Best Streak & Completion
                        TwinMetricsGrid()
                        
                        // Section Kalender: Consistency Tracker
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Consistency")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                            
                            ConsistencyCalendarView()
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 90)
                }
            }
            .safeAreaPadding(.top) // Menghormati batas poni / Dynamic Island iPhone
        }
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
    var body: some View {
        ZStack(alignment: .bottomTrailing) { // Mengunci semua elemen overlay ke pojok kanan bawah
            
            // Konten Utama Card (Teks di kiri, ruang kosong di kanan)
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Streak")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text("7 Days")
                        .font(.system(size: 28, weight: .black))
                        .foregroundColor(Color("primary"))
                    
                    Text("Your current streak")
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
            Image("dart") // Nama aset gambar target panah Anda
                .resizable()
                .scaledToFit()
                .frame(width: 130, height: 130) // Sesuaikan ukuran gambar agar pas
                .offset(x: 0, y: 15) // Menggeser sedikit ke kanan bawah sesuai gambar contoh Anda
            
        }
        // --- FORMULA GLASSMORPHISM SAMA SEPERTI SEBELUMNYA ---
        .background(
            ZStack {
                Color("primary").opacity(0.04)
            }
        )
        .cornerRadius(16) // Kunci lengkungan sudut card utama
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
        /* KUNCI UTAMA: Memotong gambar dart yang keluar dari batas
           tanpa memengaruhi ukuran lebar layout horizontal luar card */
        .clipped()
    }
}

// MARK: - 3. TWIN METRICS GRID (KARTU KEMBAR)
struct TwinMetricsGrid: View {
    var body: some View {
        HStack(spacing: 16) {
            
            // Kartu Kiri: Best Streak
            VStack(alignment: .leading, spacing: 14) {
                Image(systemName: "medal.star") // Gunakan icon piala/medali kustom Anda jika ada
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(width: 45, height: 45)
                    .background(Circle().fill(Color.white.opacity(0.08)))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Best Streak")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.gray)
                    
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("100")
                            .font(.system(size: 26, weight: .black))
                            .foregroundColor(Color("primary"))
                        Text("Days")
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
                Image(systemName: "chart.pie") // Icon lingkaran diagram completion
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(width: 45, height: 45)
                    .background(Circle().fill(Color.white.opacity(0.08)))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Completion")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.gray)
                    
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("75")
                            .font(.system(size: 26, weight: .black))
                            .foregroundColor(Color("secondary"))
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
    // State untuk menyimpan bulan dan tahun yang sedang aktif dilihat oleh user
    @State private var currentMonthDate = Date()
    
    let daysOfWeek = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    
    var body: some View {
        VStack(spacing: 20) {
            // Header Kalender: Nama Bulan & Tahun Riil beserta Tombol Navigasi
            HStack {
                Text(formatMonthYear(currentMonthDate))
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                HStack(spacing: 20) {
                    // Tombol ganti ke bulan sebelumnya
                    Button(action: { changeMonth(by: -1) }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.blue)
                    }
                    // Tombol ganti ke bulan berikutnya
                    Button(action: { changeMonth(by: 1) }) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.blue)
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
                        // Slot kosong sebelum tanggal 1 dimulai
                        Text("")
                            .frame(height: 34)
                    } else {
                        let dateNumber = index - firstDayOffset + 1
                        let isToday = checkIsToday(dateNumber: dateNumber)
                        
                        Text("\(dateNumber)")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(isToday ? .white : .white.opacity(0.8))
                            .frame(width: 34, height: 34)
                            // Efek lingkaran biru tipis untuk menandai hari ini
                            .background(
                                isToday ? Circle().fill(Color.blue.opacity(0.2)) : nil
                            )
                            .overlay(
                                isToday ? Circle().stroke(Color.blue, lineWidth: 1) : nil
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
    
    // 1. Mendapatkan teks nama bulan dan tahun (misal: "April 2026")
    private func formatMonthYear(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
    
    // 2. Menghitung berapa banyak hari dalam bulan tersebut (28, 29, 30, atau 31 hari)
    private func getDaysInMonth() -> Int {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: currentMonthDate)!
        return range.count
    }
    
    // 3. Menghitung hari pertama bulan tersebut jatuh di hari apa (SUN = 0, MON = 1, dst)
    private func getFirstDayOfWeekOffset() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: currentMonthDate)
        let firstDayOfMonth = calendar.date(from: components)!
        // Nilai bawaan weekday iOS: Minggu = 1, Senin = 2... dikurang 1 agar pas indeks 0
        return calendar.component(.weekday, from: firstDayOfMonth) - 1
    }
    
    // 4. Memeriksa apakah sel tanggal tersebut merupakan hari ini (Real-time Match)
    private func checkIsToday(dateNumber: Int) -> Bool {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month], from: currentMonthDate)
        components.day = dateNumber
        
        guard let targetDate = calendar.date(from: components) else { return false }
        return calendar.isDateInToday(targetDate)
    }
    
    // 5. Fungsi aksi untuk berpindah bulan saat tombol panah ditekan
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
