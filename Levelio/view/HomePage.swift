//
//  HomePage.swift
//  Levelio
//
//  Created by Irene Ancilla Chow on 30/05/26.
//

import SwiftUI
import CoreData

struct HomePage: View {
    @AppStorage("currentUserId") private var currentUserId = ""
    @AppStorage("currentUserName") private var currentUserName = ""
    
    static let sharedHabitService = HabitService(context: PersistenceController.shared.container.viewContext)
    static let sharedHabitStore = HabitStore()
    
    @Environment(\.managedObjectContext) private var viewContext
    @State private var selectedTab = 0
    @State private var currentUser: UserEntity?
    
    // 1. Saklar state untuk mengontrol buka/tutup lembaran AddPage dan Ad Page
    @State private var isPresentingAddPage = false
    @State private var isPresentingAdPage = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            // --- TAB 0: HOME ---
            HomeTabContent(
                store: HomePage.sharedHabitStore,
                habitService: HomePage.sharedHabitService,
                user: currentUser,
                userName: currentUserName
            )
                .tabItem {
                    Label("Home", systemImage: selectedTab == 0 ? "house.fill" : "house")
                }
                .tag(0)
            
            // --- TAB 1: STATS ---
            StatsPage(
                user: currentUser,
                store: HomePage.sharedHabitStore,
                habitService: HomePage.sharedHabitService
            )
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
            ChallengesPage(
                user: currentUser,
                store: HomePage.sharedHabitStore,
                habitService: HomePage.sharedHabitService
            )
                .tabItem {
                    Label("Challenges", systemImage: selectedTab == 3 ? "trophy.fill" : "trophy")
                }
                .tag(3)
            
            let context = PersistenceController.shared.container.viewContext
            let userService = UserService(context: context)
            
            // --- TAB 4: PROFILE ---
            ProfilePage(
                user: currentUser,
                habitService: HomePage.sharedHabitService,
                userService: userService,
                store: HomePage.sharedHabitStore
            )
                .tabItem {
                    Label("Profile", systemImage: selectedTab == 4 ? "person.fill" : "person")
                }
                .tag(4)
        }
        .tint(.blue)
        .preferredColorScheme(.dark)
        .task(id: currentUserId) {
            loadCurrentUser()
        }
        .onAppear {
            loadCurrentUser()
        }
        .onChange(of: currentUserId) { _, _ in
            loadCurrentUser()
        }
        
        // 2. DETEKSI AMAN: Begitu user mengetuk Tab, periksa tab dan role admin/premium
        .onChange(of: selectedTab) { oldValue, newValue in
            if newValue == 0 {
                loadCurrentUser()
            }
            if newValue == 2 {
                // Kembalikan seleksi tab aktif ke halaman sebelumnya agar tidak macet di layar kosong
                selectedTab = oldValue
                
                let userEmail = currentUser?.email?.lowercased() ?? ""
                let isAdmin = userEmail.hasSuffix("@dev.co.id") || userEmail.contains("dev.co.id") || currentUser?.role == "developer"
                let isPremium = currentUser?.role == "premium"
                
                if isAdmin || isPremium {
                    // Jika admin atau premium, langsung tampilkan AddPage tanpa iklan
                    isPresentingAddPage = true
                } else {
                    // Jika bukan admin/premium, tampilkan iklan SubscriptionPage terlebih dahulu
                    isPresentingAdPage = true
                }
            }
        }
        
        // 3. TAMPILAN IKLAN SUBSCRIPTION PAGE (Untuk user non-admin / non-premium)
        .fullScreenCover(isPresented: $isPresentingAdPage) {
            SubscriptionPage(user: currentUser, isAdMode: true, onAdDismissed: {
                loadCurrentUser()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    isPresentingAddPage = true
                }
            })
        }
        
        // 4. Memanggil AddPage langsung tanpa NavigationStack agar tidak ada duplikasi tombol back
        .fullScreenCover(isPresented: $isPresentingAddPage) {
            AddPage(store: HomePage.sharedHabitStore)
        }
    }
    
    private func loadCurrentUser() {
        guard let uuid = UUID(uuidString: currentUserId) else { return }
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)
        request.fetchLimit = 1
        
        if let fetchedUser = try? viewContext.fetch(request).first {
            currentUser = fetchedUser
            if let name = fetchedUser.fullName, !name.isEmpty {
                currentUserName = name
            }
            HomePage.sharedHabitStore.refresh(for: fetchedUser)
        }
    }
}

// MARK: - KONTEN UTAMA HALAMAN HOME
struct HomeTabContent: View {
    @ObservedObject var store: HabitStore
    var habitService: HabitService
    let user: UserEntity?
    var userName: String = ""
    
    @State private var habitToDelete: HabitEntity? = nil
    @State private var showDeleteConfirmation = false
    @State private var showResetConfirmation = false
    
    private var isCompactScreen: Bool {
        UIScreen.isCompact
    }
    
    private var currentStage: DinoStage {
        DinoStage.stage(for: store.totalXP)
    }
    
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
                HeaderView(user: user, userName: userName, streak: store.currentStreak)
                    .padding(.horizontal, 24)
                    .padding(.top, 12)
                    .padding(.bottom, isCompactScreen ? 8 : 16)
                
                // --- AREA 2: HERO, TIMELINE, XP CARD ---
                VStack(alignment: .leading, spacing: isCompactScreen ? 12 : 20) {
                    EggHeroSection(stage: currentStage, isCompact: isCompactScreen)
                    
                    EvolutionJourneyTimeline(user: user, userName: userName, currentStage: currentStage, isCompact: isCompactScreen)
                    
                    XpProgressCard(totalXP: store.totalXP, stage: currentStage, isCompact: isCompactScreen)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, isCompactScreen ? 10 : 16)
                
                // --- AREA 2: SCROLLABLE (Hanya bagian progress ke bawah) ---
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: isCompactScreen ? 16 : 22) {
                        
                        HabitSectionView(
                            title: "Today's Progress",
                            status: .active,
                            habits: store.habits.filter { !$0.isCompleted },
                            onToggle: { habit in
                                if let habitId = habit.habitId {
                                    store.toggleCompletion(for: habitId, user: user)
                                }
                            },
                            onDelete: { habit in
                                habitToDelete = habit
                                showDeleteConfirmation = true
                            },
                            onReset: store.habits.contains { $0.isCompleted } ? {
                                showResetConfirmation = true
                            } : nil
                        )
                        
                        HabitSectionView(
                            title: "Past Progress",
                            status: .completed,
                            habits: store.habits.filter { $0.isCompleted },
                            onToggle: { habit in
                                if let habitId = habit.habitId {
                                    store.toggleCompletion(for: habitId, user: user)
                                }
                            },
                            onDelete: { habit in
                                habitToDelete = habit
                                showDeleteConfirmation = true
                            }
                        )
                        
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 5)
                    .padding(.bottom, 24)
                }
            }
        }
        .alert("Reset Daily Habits?", isPresented: $showResetConfirmation) {
            Button("Reset", role: .destructive) {
                store.resetAllHabits(for: user)
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will uncheck all completed habits so you can track them again today.")
        }
        .alert("Delete Habit?", isPresented: $showDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                if let habit = habitToDelete, let id = habit.habitId {
                    store.deleteHabit(id: id, user: user)
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to permanently delete '\(habitToDelete?.title ?? "this habit")'?")
        }
    }
}

// MARK: - 1. HEADER VIEW
struct HeaderView: View {
    var user: UserEntity?
    var userName: String = ""
    var streak: Int = 0
    
    private var firstName: String {
        let effectiveName = !userName.isEmpty ? userName : (user?.fullName ?? "")
        let first = effectiveName.trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: " ")
            .first?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return first.isEmpty ? "Explorer" : first
    }
    
    private var greetingPrefix: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:
            return "Good morning"
        case 12..<17:
            return "Good afternoon"
        case 17..<21:
            return "Good evening"
        default:
            return "Good night"
        }
    }
    
    var formattedToday: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMMM yyyy"
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: Date())
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(greetingPrefix), \(firstName)!")
                    .font(.system(size: 26, weight: .heavy))
                    .foregroundColor(.white)
                
                Text(formattedToday)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Streak Flame Pill Badge
            HStack(spacing: 5) {
                Image(systemName: "flame.fill")
                    .font(.system(size: 13))
                    .foregroundColor(streak > 0 ? .orange : .gray)
                
                Text("\(streak) \(streak == 1 ? "Day" : "Days")")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(streak > 0 ? .white : .gray)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background(
                Capsule()
                    .fill(streak > 0 ? Color.orange.opacity(0.15) : Color.white.opacity(0.06))
            )
            .overlay(
                Capsule()
                    .stroke(streak > 0 ? Color.orange.opacity(0.4) : Color.white.opacity(0.1), lineWidth: 1)
            )
            
            // Avatar Dino Lingkaran Berwarna Hijau
            Image("ava-1") // Pastikan asset disiapkan di Assets catalog
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .background(Circle().fill(Color.white.opacity(0.1)))
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1))
        }
    }
}

// MARK: - 2. EGG HERO SECTION
struct EggHeroSection: View {
    let stage: DinoStage
    var isCompact: Bool = false
    
    var body: some View {
        HStack {
            Spacer()
            ZStack(alignment: .topTrailing) {
                // Gambar Pet Sesuai Tahap Evolusi
                Image(stage.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: isCompact ? 110 : 155)
                    .shadow(color: Color.blue.opacity(0.3), radius: 20, x: 0, y: 10)
                    .animation(.spring(response: 0.45, dampingFraction: 0.7), value: stage)
                
                // Balon Dialog Berbasis Stage
                SpeechBubbleView(stage: stage)
                    .offset(x: stage == .egg ? 50 : 35, y: -20)
            }
            Spacer()
        }
        .padding(.vertical, isCompact ? 2 : 6)
    }
}

struct SpeechBubbleView: View {
    let stage: DinoStage
    
    var body: some View {
        if stage == .egg {
            Image("speech-bubble")
                .resizable()
                .scaledToFit()
                .frame(width: 70)
        } else {
            HStack(spacing: 4) {
                Text(stage.speechBubbleText)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Color("primary"))
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(Color.black.opacity(0.6))
                    .overlay(Capsule().stroke(Color("secondary").opacity(0.6), lineWidth: 1.5))
            )
        }
    }
}

// MARK: - 3. EVOLUTION JOURNEY TIMELINE
struct EvolutionJourneyTimeline: View {
    let user: UserEntity?
    var userName: String = ""
    let currentStage: DinoStage
    var isCompact: Bool = false
    
    private var displayName: String {
        let effectiveName = !userName.isEmpty ? userName : (user?.fullName ?? "")
        return effectiveName.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: isCompact ? 8 : 12) {
            Text(displayName.isEmpty ? "Evolution Journey" : "\(displayName)'s Evolution Journey")
                .font(.system(size: isCompact ? 17 : 20, weight: .bold))
                .foregroundColor(.white)
            
            HStack(spacing: 0) {
                TimelineNode(imageName: "dino-egg-blue", label: "Egg", isActive: currentStage.level >= 1, isCompact: isCompact)
                TimelineLine(isActive: currentStage.level >= 2)
                TimelineNode(imageName: "dino-hatch-blue", label: "Hatchling", isActive: currentStage.level >= 2, isCompact: isCompact)
                TimelineLine(isActive: currentStage.level >= 3)
                TimelineNode(imageName: "dino-baby-blue", label: "Baby Dino", isActive: currentStage.level >= 3, isCompact: isCompact)
                TimelineLine(isActive: currentStage.level >= 4)
                TimelineNode(imageName: "dino-adult-blue", label: "Adult Dino", isActive: currentStage.level >= 4, isCompact: isCompact)
            }
        }
    }
}

struct TimelineNode: View {
    let imageName: String
    let label: String
    let isActive: Bool
    var isCompact: Bool = false
    
    var body: some View {
        VStack(spacing: isCompact ? 4 : 6) {
            ZStack {
                Circle()
                    .fill(isActive ? Color.white.opacity(0.15) : Color.white.opacity(0.04))
                    .frame(width: isCompact ? 36 : 44, height: isCompact ? 36 : 44)
                    .overlay(
                        Circle()
                            .stroke(isActive ? Color("secondary") : Color.white.opacity(0.1), lineWidth: isActive ? 2 : 1)
                    )
                
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: isCompact ? 20 : 26, height: isCompact ? 20 : 26)
                    .opacity(isActive ? 1.0 : 0.4)
            }
            
            Text(label)
                .font(.system(size: isCompact ? 9 : 10, weight: isActive ? .bold : .medium))
                .foregroundColor(isActive ? .white : .gray)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity)
        .animation(.easeInOut(duration: 0.3), value: isActive)
    }
}

struct TimelineLine: View {
    var isActive: Bool = false
    
    var body: some View {
        Rectangle()
            .fill(isActive ? Color("secondary") : Color.white.opacity(0.15))
            .frame(height: 2)
            .offset(y: -10)
            .animation(.easeInOut(duration: 0.3), value: isActive)
    }
}

// MARK: - 4. XP PROGRESS CARD
struct XpProgressCard: View {
    let totalXP: Int
    let stage: DinoStage
    var isCompact: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: isCompact ? 8 : 12) {
            // Label Level Saat Ini & XP Numeric Indicator
            HStack {
                Text("Level \(stage.level): \(stage.name)")
                    .font(.system(size: isCompact ? 14 : 16, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                if stage.isMaxLevel {
                    Text("\(totalXP) XP (MAX)")
                        .font(.system(size: isCompact ? 12 : 14, weight: .bold))
                        .foregroundColor(Color("secondary"))
                } else {
                    Text("\(totalXP) / \(stage.targetXP) XP")
                        .font(.system(size: isCompact ? 12 : 14, weight: .bold))
                        .foregroundColor(Color("secondary"))
                }
            }
            
            // Custom Linear Progress Bar Capsul
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 6)
                    
                    Capsule()
                        .fill(LinearGradient(colors: [Color("secondary"), Color("secondary").opacity(0.6)], startPoint: .leading, endPoint: .trailing))
                        .frame(width: max(0, min(geo.size.width, geo.size.width * CGFloat(stage.progressRatio(for: totalXP)))), height: 6)
                        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: totalXP)
                }
            }
            .frame(height: 6)
            
            // Keterangan Sisa Angka XP Menuju Evolusi Selanjutnya
            HStack(spacing: 4) {
                Image(systemName: "megaphone.fill")
                    .font(.system(size: 11))
                
                if stage.isMaxLevel {
                    Text("Max level reached! Dino is fully grown!")
                        .fontWeight(.semibold)
                        .foregroundColor(Color("primary"))
                } else if stage == .egg {
                    Text("\(stage.remainingXP(for: totalXP)) XP left to hatch into")
                    Text("Hatchling")
                        .fontWeight(.bold)
                        .foregroundColor(Color("primary"))
                } else {
                    Text("\(stage.remainingXP(for: totalXP)) XP left to evolve into")
                    Text(stage.nextStage?.name ?? "")
                        .fontWeight(.bold)
                        .foregroundColor(Color("primary"))
                }
            }
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(.gray)
        }
        .padding(.all, isCompact ? 12 : 16)
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
    let habits: [HabitEntity]
    let onToggle: (HabitEntity) -> Void
    var onDelete: ((HabitEntity) -> Void)? = nil
    var onReset: (() -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text(title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                if let onReset = onReset {
                    Button(action: onReset) {
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.counterclockwise")
                                .font(.system(size: 11, weight: .bold))
                            Text("Reset")
                                .font(.system(size: 11, weight: .bold))
                        }
                        .foregroundColor(.gray)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.white.opacity(0.08))
                        .cornerRadius(8)
                    }
                    .frame(minWidth: 44, minHeight: 44)
                }
                
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
                    HabitRowCard(
                        habit: habit,
                        status: status,
                        onToggle: { onToggle(habit) },
                        onDelete: onDelete != nil ? { onDelete?(habit) } : nil
                    )
                }
            }
        }
    }
}

struct HabitRowCard: View {
    let habit: HabitEntity
    let status: HabitStatus
    let onToggle: () -> Void
    var onDelete: (() -> Void)? = nil
    
    private var habitColor: Color {
        switch habit.colorName?.lowercased() {
        case "secondary", "purple":
            return Color("secondary")
        case "tertiary", "indigo", "blue":
            return Color("tertiary")
        default:
            return Color("primary")
        }
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Button(action: onToggle) {
                HStack(spacing: 16) {
                    // Indikator Titik Berwarna Lingkaran Sesuai Pilihan Warna Habit
                    Circle()
                        .fill(status == .active ? habitColor.opacity(0.9) : habitColor.opacity(0.4))
                        .frame(width: 20, height: 20)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(habit.title ?? "Untitled Habit")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(habit.time ?? "08.00am")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    // Info XP & Status Centang Kanan
                    if status == .active {
                        Text("+\(habit.xpReward)XP")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(habitColor.opacity(0.9))
                        
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
            }
            .buttonStyle(PlainButtonStyle())
            
            if let onDelete = onDelete {
                Menu {
                    Button(role: .destructive, action: onDelete) {
                        Label("Delete Habit", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.gray.opacity(0.6))
                        .frame(width: 36, height: 36)
                        .contentShape(Rectangle())
                }
                .frame(width: 44, height: 44)
                .padding(.leading, 4)
            }
        }
        .padding(.leading, 16)
        .padding(.trailing, onDelete != nil ? 8 : 16)
        .padding(.vertical, 12)
        .background(Color.white.opacity(0.04))
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
        .contextMenu {
            if let onDelete = onDelete {
                Button(role: .destructive, action: onDelete) {
                    Label("Delete Habit", systemImage: "trash")
                }
            }
        }
    }
}

#Preview {
    HomePage()
}
