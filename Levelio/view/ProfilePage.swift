//
//  ProfilePage.swift
//  Levelio
//
//  Created by Irene Ancilla Chow on 30/05/26.
//

import SwiftUI
import CoreData
import Combine

struct ProfilePage: View {
    @Environment(\.managedObjectContext) private var viewContext
    @AppStorage("isUserLoggedIn") private var isUserLoggedIn = true
    @AppStorage("currentUserId") private var currentUserId = ""
    @AppStorage("currentUserName") private var currentUserName = ""
    
    var user: UserEntity?
    var habitService: HabitService
    var userService: UserService
    @ObservedObject var store: HabitStore = HomePage.sharedHabitStore
    
    @State private var fullName: String = ""
    @State private var birthDate: Date = Date()
    @State private var selectedGender: String = "Prefer not to say"
    @State private var isEditingName: Bool = false
    @State private var isEditingBirthDate: Bool = false
    
    private var totalXP: Int {
        store.totalXP
    }
    
    private var currentStage: DinoStage {
        DinoStage.stage(for: totalXP)
    }
    
    private var formattedBirthDateString: String {
        userService.formattedDate(birthDate)
    }
    
    private var levelersSinceString: String {
        user?.createdDate?.formatted(
            .dateTime.month(.wide).day().year().locale(Locale(identifier: "en_US"))
        ) ?? "-"
    }
    
    private var isCompactScreen: Bool {
        UIScreen.isCompact
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                // --- 1. APP BAR / NAVIGATION HEADER ---
                HStack {
                    // Counterbalance 36x36 agar judul "Profile" tepat di tengah
                    Color.clear
                        .frame(width: 36, height: 36)
                    
                    Spacer()
                    
                    Text("Profile")
                        .font(.system(size: 22, weight: .heavy))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button {
                        currentUserId = ""
                        currentUserName = ""
                        isUserLoggedIn = false
                    } label: {
                        Image(systemName: "rectangle.portrait.and.arrow.forward")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 36, height: 36)
                            .background(Circle().fill(Color.white.opacity(0.12)))
                    }
                }
                .frame(height: 44)
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, isCompactScreen ? 8 : 12)
                
                // --- AREA STATIS ATAS (STAY / TIDAK IKUT SCROLL) ---
                VStack(alignment: .leading, spacing: isCompactScreen ? 14 : 20) {
                    // USER HERO SECTION (Avatar & ID)
                    HStack(spacing: 16) {
                        Image("ava-1")
                            .resizable()
                            .scaledToFill()
                            .frame(width: isCompactScreen ? 60 : 75, height: isCompactScreen ? 60 : 75)
                            .background(Color.white.opacity(0.1))
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white.opacity(0.2), lineWidth: 1))
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(fullName.isEmpty ? (user?.fullName ?? "Explorer") : fullName)
                                .font(.system(size: isCompactScreen ? 18 : 20, weight: .bold))
                                .foregroundColor(.white)
                            Text(user?.levelioId ?? "LV00000")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal, 4)
                    
                    // LEVEL & XP PROGRESS BAR
                    VStack(spacing: 8) {
                        HStack {
                            Text("Level \(currentStage.level)")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.white)
                            Spacer()
                            if currentStage.isMaxLevel {
                                Text("\(totalXP) XP (MAX)")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.gray)
                            } else {
                                Text("\(totalXP)/\(currentStage.targetXP) XP")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(Color.white.opacity(0.15))
                                    .frame(height: 6)
                                Capsule()
                                    .fill(Color.cyan)
                                    .frame(width: max(0, min(geo.size.width, geo.size.width * CGFloat(currentStage.progressRatio(for: totalXP)))), height: 6)
                                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: totalXP)
                            }
                        }
                        .frame(height: 6)
                    }
                    
                    // QUICK STATS MATRIX CARD (4 Kolom)
                    HStack(spacing: 0) {
                        VStack(spacing: 4) {
                            Text("🔥 \(store.currentStreak)").font(.system(size: 15, weight: .bold))
                            Text("Streak").font(.system(size: 11, weight: .medium)).foregroundColor(.gray)
                        }.frame(maxWidth: .infinity)
                        
                        Divider().background(Color.white.opacity(0.2)).frame(height: 28)
                        
                        VStack(spacing: 4) {
                            Text("⚡️ \(store.todayXP)").font(.system(size: 15, weight: .bold))
                            Text("Today's XP").font(.system(size: 11, weight: .medium)).foregroundColor(.gray)
                        }.frame(maxWidth: .infinity)
                        
                        Divider().background(Color.white.opacity(0.2)).frame(height: 28)
                        
                        VStack(spacing: 4) {
                            Text("🎯 \(habitService.calculateCompletionPercentage())%").font(.system(size: 15, weight: .bold))
                            Text("Completion").font(.system(size: 11, weight: .medium)).foregroundColor(.gray)
                        }.frame(maxWidth: .infinity)
                        
                        Divider().background(Color.white.opacity(0.2)).frame(height: 28)
                        
                        VStack(spacing: 4) {
                            Text("🗓️ \(habitService.getActiveHabitCount())").font(.system(size: 15, weight: .bold))
                            Text("Active").font(.system(size: 11, weight: .medium)).foregroundColor(.gray)
                        }.frame(maxWidth: .infinity)
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, isCompactScreen ? 10 : 14)
                    .background(Color.white.opacity(0.04))
                    .cornerRadius(14)
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.08), lineWidth: 1))
                }
                .padding(.horizontal, 20)
                .padding(.top, isCompactScreen ? 4 : 8)
                
                // --- 2. SCROLLABLE CONTENT ---
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // PREMIUM STATUS OR UPGRADE BANNER
                        let isPremium = user?.role == "premium"
                        
                        ZStack(alignment: .trailing) {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack(spacing: 6) {
                                    Text(isPremium ? "✨ Levelio Premium" : "💎 Upgrade to Premium")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                    if isPremium {
                                        Text("ACTIVE")
                                            .font(.system(size: 10, weight: .black))
                                            .foregroundColor(.black)
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2)
                                            .background(Color.yellow)
                                            .cornerRadius(4)
                                    }
                                }
                                
                                Text(isPremium ? "Unlimited habits, zero ads, and all analytics unlocked." : "Level up faster with unlimited habits\n& advanced stats.")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(.white.opacity(0.7))
                                    .lineSpacing(3)
                                    .padding(.bottom, isPremium ? 2 : 8)
                                
                                if !isPremium {
                                    NavigationLink(destination: SubscriptionPage(user: user)) {
                                        Text("Upgrade Now")
                                            .font(.system(size: 13, weight: .bold))
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 20)
                                            .padding(.vertical, 9)
                                            .background(
                                                LinearGradient(
                                                    colors: [Color.blue.opacity(0.6), Color.cyan.opacity(0.8)],
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                            .cornerRadius(22)
                                            .overlay(RoundedRectangle(cornerRadius: 22).stroke(Color.white, lineWidth: 1.5))
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Image(isPremium ? "dino-premium" : "unlock")
                                .resizable()
                                .scaledToFit()
                                .frame(width: isPremium ? 70 : 75, height: isPremium ? 70 : 75)
                                .offset(x: 10, y: -10)
                        }
                        .padding(.all, 18)
                        .background(
                            LinearGradient(
                                colors: isPremium ?
                                [Color(red: 0.18, green: 0.14, blue: 0.35), Color(red: 0.12, green: 0.22, blue: 0.38)] :
                                [Color(red: 0.12, green: 0.16, blue: 0.35), Color(red: 0.15, green: 0.28, blue: 0.38)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(16)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.12), lineWidth: 1))
                        .clipped()
                        
                        // SECTION: LEVELERS SINCE
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Levelers Since")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                            
                            HStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(Color.white.opacity(0.1))
                                        .frame(width: 32, height: 32)
                                        .overlay(Circle().stroke(Color.white.opacity(0.15), lineWidth: 1))
                                    Image(systemName: "calendar")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                Text(levelersSinceString)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 16)
                            .frame(height: 50)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white.opacity(0.04))
                            .cornerRadius(25)
                            .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.white.opacity(0.08), lineWidth: 1))
                        }
                        
                        // SECTION: USER'S INFORMATION
                        VStack(alignment: .leading, spacing: 12) {
                            Text("User’s Information")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                            
                            // Row 1: Name (Editable)
                            HStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(Color.white.opacity(0.1))
                                        .frame(width: 32, height: 32)
                                        .overlay(Circle().stroke(Color.white.opacity(0.15), lineWidth: 1))
                                    Image(systemName: "person")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                
                                if isEditingName {
                                    TextField("Full Name", text: $fullName, onCommit: {
                                        isEditingName = false
                                        saveProfile()
                                    })
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        isEditingName = false
                                        saveProfile()
                                    }) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundColor(Color("secondary"))
                                    }
                                } else {
                                    Text(fullName.isEmpty ? (user?.fullName ?? "Explorer") : fullName)
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        isEditingName = true
                                    }) {
                                        Image(systemName: "pencil")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                            .frame(height: 50)
                            .background(Color.white.opacity(0.04))
                            .cornerRadius(25)
                            .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.white.opacity(0.08), lineWidth: 1))
                            
                            // Row 2: Email (Read only)
                            HStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(Color.white.opacity(0.1))
                                        .frame(width: 32, height: 32)
                                        .overlay(Circle().stroke(Color.white.opacity(0.15), lineWidth: 1))
                                    Image(systemName: "envelope")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                Text(user?.email ?? "-")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            .frame(height: 50)
                            .background(Color.white.opacity(0.04))
                            .cornerRadius(25)
                            .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.white.opacity(0.08), lineWidth: 1))
                            
                            // Row 3: Birth Date (Editable with Graphical DatePicker)
                            VStack(spacing: 0) {
                                HStack(spacing: 12) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.white.opacity(0.1))
                                            .frame(width: 32, height: 32)
                                            .overlay(Circle().stroke(Color.white.opacity(0.15), lineWidth: 1))
                                        Image(systemName: "birthday.cake")
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(.white.opacity(0.8))
                                    }
                                    
                                    Text(formattedBirthDateString)
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            isEditingBirthDate.toggle()
                                        }
                                    }) {
                                        Image(systemName: isEditingBirthDate ? "checkmark.circle.fill" : "pencil")
                                            .font(.system(size: isEditingBirthDate ? 18 : 14, weight: isEditingBirthDate ? .bold : .regular))
                                            .foregroundColor(isEditingBirthDate ? Color("secondary") : .gray)
                                    }
                                }
                                .padding(.horizontal, 16)
                                .frame(height: 50)
                                
                                if isEditingBirthDate {
                                    Divider()
                                        .background(Color.white.opacity(0.1))
                                    
                                    DatePicker("", selection: $birthDate, displayedComponents: .date)
                                        .datePickerStyle(.graphical)
                                        .colorScheme(.dark)
                                        .tint(Color("secondary"))
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .onChange(of: birthDate) { _, _ in
                                            saveProfile()
                                        }
                                }
                            }
                            .background(Color.white.opacity(0.04))
                            .cornerRadius(25)
                            .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.white.opacity(0.08), lineWidth: 1))
                            
                            // Row 4: Gender Dropdown Menu (Editable)
                            Menu {
                                Button(action: {
                                    selectedGender = "Prefer not to say"
                                    saveProfile()
                                }) {
                                    HStack {
                                        Text("Prefer not to say")
                                        if selectedGender == "Prefer not to say" { Image(systemName: "checkmark") }
                                    }
                                }
                                Button(action: {
                                    selectedGender = "Female"
                                    saveProfile()
                                }) {
                                    HStack {
                                        Text("Female")
                                        if selectedGender == "Female" { Image(systemName: "checkmark") }
                                    }
                                }
                                Button(action: {
                                    selectedGender = "Male"
                                    saveProfile()
                                }) {
                                    HStack {
                                        Text("Male")
                                        if selectedGender == "Male" { Image(systemName: "checkmark") }
                                    }
                                }
                            } label: {
                                HStack(spacing: 12) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.white.opacity(0.1))
                                            .frame(width: 32, height: 32)
                                            .overlay(Circle().stroke(Color.white.opacity(0.15), lineWidth: 1))
                                        Image(systemName: selectedGender == "Prefer not to say" ? "xmark" : (selectedGender == "Female" ? "f.circle" : "m.circle"))
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(.white.opacity(0.8))
                                    }
                                    
                                    Text(selectedGender)
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundColor(.gray)
                                }
                                .padding(.horizontal, 16)
                                .frame(height: 50)
                                .background(Color.white.opacity(0.04))
                                .cornerRadius(25)
                                .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.white.opacity(0.08), lineWidth: 1))
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, isCompactScreen ? 12 : 18)
                    .padding(.bottom, 32)
                }
                .clipped()
            }
            .background(
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            )
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .preferredColorScheme(.dark)
            .onAppear {
                loadUserProfile()
            }
            .onChange(of: user) { _, _ in
                loadUserProfile()
            }
        }
    }
    
    private func loadUserProfile() {
        guard let user = user else { return }
        let profile = userService.getUserProfile(user: user)
        fullName = profile.fullName
        selectedGender = profile.gender
        birthDate = profile.birthDate ?? Date()
    }
    
    private func saveProfile() {
        guard let user = user else { return }
        do {
            try userService.saveUserProfile(
                fullName: fullName,
                gender: selectedGender,
                birthDate: birthDate,
                user: user
            )
            currentUserName = fullName
        } catch {
            print("Failed to save user profile: \(error)")
        }
    }
}

@MainActor
class PreviewViewModel: ObservableObject {
    @Published var user: UserEntity?
    @Published var habitService: HabitService
    private let userService: UserService
    
    init() {
        let context = PersistenceController.shared.container.viewContext
        self.userService = UserService(context: context)
        self.habitService = HabitService(context: context)
        self.user = UserEntity(context: context)
    }
}

#Preview {
    let context = PersistenceController.shared.container.viewContext
    return ProfilePage(
        user: UserEntity(context: context),
        habitService: HabitService(context: context),
        userService: UserService(context: context)
    )
    .environment(\.managedObjectContext, context)
}
