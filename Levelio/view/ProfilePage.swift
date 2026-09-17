//
//  ProfilePage.swift
//  Levelio
//
//  Created by Irene Ancilla Chow on 30/05/26.
//

import SwiftUI

struct ProfilePage: View {
    @AppStorage("isUserLoggedIn") private var isUserLoggedIn = true
    @State private var selectedGender = "Prefer not to say"
    
    var user: UserEntity?
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Latar Belakang Gelap Levelio
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    
                    // --- 1. APP BAR / NAVIGATION HEADER (STAY / TIDAK IKUT SCROLL) ---
                    HStack {
                        Spacer()
                        Text("Profile")
                            .font(.system(size: 26, weight: .heavy))
                            .foregroundColor(.white)
                            .padding(.leading, 32) // Mengompensasi jarak agar teks tetap di tengah
                        Spacer()
                        
                        Button(action: {
                            isUserLoggedIn = false
                        }) {
                            Image(systemName: "rectangle.portrait.and.arrow.forward")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                        }
                    }
                    .frame(height: 55)
                    .padding(.horizontal, 24)
                    .padding(.top, 50)
                    .padding(.bottom, 20)
                    
                    // --- AREA STATIS ATAS (STAY / TIDAK IKUT SCROLL) ---
                    // Hanya menyisakan Avatar, Level Progress, dan Stat Matrix
                    VStack(alignment: .leading, spacing: 24) {
                        // USER HERO SECTION (Avatar & ID)
                        HStack(spacing: 20) {
                            Image("ava-1")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 90, height: 90)
                                .background(Color.white.opacity(0.1))
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white.opacity(0.2), lineWidth: 1))
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(user?.fullName ?? "Explorer")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                                Text(user?.levelioId ?? "LV00000")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.horizontal, 4)
                        
                        // LEVEL & XP PROGRESS BAR
                        VStack(spacing: 8) {
                            HStack {
                                Text("Level 1")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(.white)
                                Spacer()
                                Text("150/400 XP")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.gray)
                            }
                            
                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    Capsule()
                                        .fill(Color.white.opacity(0.15))
                                        .frame(height: 6)
                                    Capsule()
                                        .fill(Color.cyan)
                                        .frame(width: geo.size.width * (150.0 / 400.0), height: 6)
                                }
                            }
                            .frame(height: 6)
                        }
                        
                        // QUICK STATS MATRIX CARD (4 Kolom dengan Pembagi Garis)
                        HStack(spacing: 0) {
                            VStack(spacing: 6) {
                                Text("🔥 \(user?.streak ?? 0)").font(.system(size: 16, weight: .bold))
                                Text("Streak").font(.system(size: 12, weight: .medium)).foregroundColor(.gray)
                            }.frame(maxWidth: .infinity)
                            
                            Divider().background(Color.white.opacity(0.2)).frame(height: 30)
                            
                            VStack(spacing: 6) {
                                Text("⚡️ 120").font(.system(size: 16, weight: .bold))
                                Text("Today's XP").font(.system(size: 12, weight: .medium)).foregroundColor(.gray)
                            }.frame(maxWidth: .infinity)
                            
                            Divider().background(Color.white.opacity(0.2)).frame(height: 30)
                            
                            VStack(spacing: 6) {
                                Text("🎯 40%").font(.system(size: 16, weight: .bold))
                                Text("Completion").font(.system(size: 12, weight: .medium)).foregroundColor(.gray)
                            }.frame(maxWidth: .infinity)
                            
                            Divider().background(Color.white.opacity(0.2)).frame(height: 30)
                            
                            VStack(spacing: 6) {
                                Text("🗓️ 10").font(.system(size: 16, weight: .bold))
                                Text("Active").font(.system(size: 12, weight: .medium)).foregroundColor(.gray)
                            }.frame(maxWidth: .infinity)
                        }
                        .foregroundColor(.white)
                        .padding(.vertical, 16)
                        .background(Color.white.opacity(0.04))
                        .cornerRadius(14)
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.08), lineWidth: 1))
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 10)
                    
                    // --- 2. KUNCI UTAMA: SCROLLABLE CONTENT (CARD PREMIUM MASUK KE SINI) ---
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 24) {
                            
                            // UPGRADE TO PREMIUM BANNER (Sekarang ikut ter-scroll)
                            ZStack(alignment: .trailing) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("💎 Upgrade to Premium")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                    Text("Level up faster with unlimited habits\n& advanced stats.")
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(.white.opacity(0.7))
                                        .lineSpacing(3)
                                        .padding(.bottom, 10)
                                    
                                    // Sekarang menggunakan NavigationLink agar bisa push ke halaman subscription
                                    NavigationLink(destination: SubscriptionPage()) {
                                        Text("Upgrade Now")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 24)
                                            .padding(.vertical, 10)
                                            .background(
                                                LinearGradient(
                                                    colors: [Color.blue.opacity(0.6), Color.cyan.opacity(0.8)],
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                            .cornerRadius(25)
                                            .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.white, lineWidth: 1.5))
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Image("unlock")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .offset(x: 15, y: -15)
                            }
                            .padding(.all, 20)
                            .background(LinearGradient(colors: [Color(red: 0.12, green: 0.16, blue: 0.35), Color(red: 0.15, green: 0.28, blue: 0.38)], startPoint: .topLeading, endPoint: .bottomTrailing))
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
                                    Text(user?.createdDate?
                                        .formatted(
                                            .dateTime.month(.wide).day().year()
                                            .locale(Locale(identifier: "en_US"))
                                        ) ?? "-")
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundColor(.white)
                                }
                                .padding(.horizontal, 16)
                                .frame(height: 52)
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
                                
                                // Row 1: Name
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
                                    Text(user?.fullName ?? "Explorer")
                                    Spacer()
                                    Image(systemName: "pencil")
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                }
                                .padding(.horizontal, 16)
                                .frame(height: 52)
                                .background(Color.white.opacity(0.04))
                                .cornerRadius(25)
                                .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.white.opacity(0.08), lineWidth: 1))
                                
                                // Row 2: Email
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
                                    Spacer()
                                }
                                .padding(.horizontal, 16)
                                .frame(height: 52)
                                .background(Color.white.opacity(0.04))
                                .cornerRadius(25)
                                .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.white.opacity(0.08), lineWidth: 1))
                                
                                // Row 3: Birth Date
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
                                    Text("12-03-2004")
                                    Spacer()
                                }
                                .padding(.horizontal, 16)
                                .frame(height: 52)
                                .background(Color.white.opacity(0.04))
                                .cornerRadius(25)
                                .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.white.opacity(0.08), lineWidth: 1))
                                
                                // Row 4: Gender Dropdown Menu
                                Menu {
                                    Button(action: { selectedGender = "Prefer not to say" }) {
                                        HStack {
                                            Text("Prefer not to say")
                                            if selectedGender == "Prefer not to say" { Image(systemName: "checkmark") }
                                        }
                                    }
                                    Button(action: { selectedGender = "Female" }) {
                                        HStack {
                                            Text("Female")
                                            if selectedGender == "Female" { Image(systemName: "checkmark") }
                                        }
                                    }
                                    Button(action: { selectedGender = "Male" }) {
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
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.horizontal, 16)
                                    .frame(height: 52)
                                    .background(Color.white.opacity(0.04))
                                    .cornerRadius(25)
                                    .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.white.opacity(0.08), lineWidth: 1))
                                }
                            }
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.white)
                        }
                        .padding(.horizontal, 24)
                        // Mengubah jarak atas ScrollView internal ke 24 agar sejajar rapi di bawah baris Stat Matrix
                        .padding(.top, 24)
                        .padding(.bottom, 110)
                    }
                    .clipped() // Mengunci pemotongan scroll tepat di bawah Stat Matrix Card bawaan
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    ProfilePage()
}
