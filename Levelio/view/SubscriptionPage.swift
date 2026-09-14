//
//  SubscriptionPage.swift
//  Levelio
//
//  Created by Irene Ancilla Chow on 30/05/26.
//

import SwiftUI

struct SubscriptionPage: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPlan = "Yearly" // Opsi default: Yearly vs Monthly
    
    // List Benefit Premium
    let benefits = [
        (icon: "⭐️", text: "Stay consistent with Unlimited Habits"),
        (icon: "📊", text: "Track progress with Advanced Insights"),
        (icon: "🎨", text: "Make it fun with Avatar & Streak Pet"),
        (icon: "🏆", text: "Join Exclusive Challenges"),
        (icon: "🚫", text: "No Ads. No distractions")
    ]
    
    var body: some View {
        ZStack {
            // Latar Belakang Gelap Khas Levelio
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                // --- 1. TOP HEADER ACTIONS ---
                // Blok HStack penutup kustom lama Anda telah dihapus penuh dari sini,
                // karena tombol kembali (Back) sekarang dikelola otomatis oleh Navigation Bar bawaan iOS.
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 28) {
                        
                        // --- 2. HERO CHARACTER ART ---
                        VStack(spacing: 16) {
                            Image("dino-premium")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 140)
                                .shadow(color: Color.green.opacity(0.3), radius: 20, x: 0, y: 10)
                            
                            VStack(spacing: 6) {
                                Text("Master Your Routine With Premium")
                                    .font(.system(size: 24, weight: .black))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                
                                Text("Level up faster and achieve more with Premium")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.top, 20)
                        
                        // --- 3. PREMIUM BENEFITS BOX ---
                        VStack(alignment: .leading, spacing: 16) {
                            ForEach(benefits, id: \.text) { benefit in
                                HStack(spacing: 14) {
                                    Text(benefit.icon)
                                        .font(.system(size: 16))
                                    Text(benefit.text)
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.white.opacity(0.9))
                                    Spacer()
                                }
                            }
                        }
                        .padding(.all, 20)
                        .background(Color("primary").opacity(0.04))
                        .cornerRadius(16)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.1), lineWidth: 1))
                        .padding(.horizontal, 24)
                        
                        // --- 4. CHOOSE YOUR PLAN SECTION ---
                        VStack(spacing: 16) {
                            // Separator Text
                            HStack(alignment: .center) {
                                Rectangle()
                                    .fill(LinearGradient(colors: [.clear, .white.opacity(0.2)], startPoint: .leading, endPoint: .trailing))
                                    .frame(height: 1)
                                
                                Text("Choose Your Plan")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white.opacity(0.6))
                                    .padding(.horizontal, 8)
                                    .layoutPriority(1)
                                    .fixedSize(horizontal: true, vertical: false)
                                
                                Rectangle()
                                    .fill(LinearGradient(colors: [.white.opacity(0.2), .clear], startPoint: .leading, endPoint: .trailing))
                                    .frame(height: 1)
                            }
                            .padding(.horizontal, 24)
                            .padding(.bottom, 10)
                            
                            // Plan Selector Grid (Monthly vs Yearly)
                            HStack(spacing: 16) {
                                // PLAN 1: MONTHLY
                                Button(action: { selectedPlan = "Monthly" }) {
                                    VStack(spacing: 4) {
                                        Text("Pay Monthly")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(.white)
                                        Text("$3.99")
                                            .font(.system(size: 26, weight: .black))
                                            .foregroundColor(.white)
                                        Text("($3.99/mo)")
                                            .font(.system(size: 11, weight: .medium))
                                            .foregroundColor(.gray)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 110)
                                    .background(Color.white.opacity(0.04))
                                    .cornerRadius(14)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14)
                                            .strokeBorder(
                                                selectedPlan == "Monthly" ?
                                                LinearGradient(
                                                    colors: [
                                                        Color("primary"),
                                                        Color("secondary"),
                                                        Color("tertiary")
                                                    ],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                ) :
                                                LinearGradient(colors: [Color.white.opacity(0.08)], startPoint: .leading, endPoint: .trailing),
                                                lineWidth: selectedPlan == "Monthly" ? 2 : 1
                                            )
                                            .shadow(
                                                color: selectedPlan == "Monthly" ? .purple.opacity(0.5) : .clear, radius: 10
                                            )
                                    )
                                }
                                
                                // PLAN 2: YEARLY (WITH GLOW & POPULAR BADGE)
                                Button(action: { selectedPlan = "Yearly" }) {
                                    ZStack(alignment: .top) {
                                        VStack(spacing: 4) {
                                            Text("Pay Yearly")
                                                .font(.system(size: 14, weight: .bold))
                                                .foregroundColor(.white)
                                            Text("$29.99")
                                                .font(.system(size: 26, weight: .black))
                                                .foregroundColor(.white)
                                            Text("($2.50/mo)")
                                                .font(.system(size: 11, weight: .medium))
                                                .foregroundColor(.gray)
                                        }
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 110)
                                        .background(Color.white.opacity(0.06))
                                        .cornerRadius(14)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 14)
                                                .strokeBorder(
                                                    selectedPlan == "Yearly" ?
                                                    LinearGradient(
                                                        colors: [
                                                            Color("primary"),
                                                            Color("secondary"),
                                                            Color("tertiary")
                                                        ],
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    ) :
                                                    LinearGradient(colors: [Color.white.opacity(0.08)], startPoint: .leading, endPoint: .trailing),
                                                    lineWidth: selectedPlan == "Yearly" ? 2 : 1
                                                )
                                                .shadow(
                                                    color: selectedPlan == "Yearly" ? .purple.opacity(0.5) : .clear, radius: 10
                                                )
                                        )
                                        
                                        // Badge Terpopuler Melayang
                                        Text("Most Popular 🔥")
                                            .font(.system(size: 10, weight: .heavy))
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 4)
                                            .background(
                                                LinearGradient(
                                                    colors: [
                                                        Color("tertiary"),
                                                        Color("secondary"),
                                                        Color("primary")
                                                    ],
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                            .cornerRadius(10)
                                            .offset(y: -12)
                                    }
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                    }
                    .padding(.top, 24) // Ditambahkan sedikit jarak atas agar konten seimbang tanpa header manual
                    .padding(.bottom, 20)
                }
                
                // --- 5. FIXED BOTTOM ACTION BUTTON ---
                VStack(spacing: 12) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Get Full Access Now")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                LinearGradient(
                                    colors: [
                                        Color("tertiary"),
                                        Color("secondary"),
                                        Color("primary")
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(25)
                    }
                    
                    // Legal Terms links
                    HStack(spacing: 6) {
                        Text("Term of Service")
                        Text("•")
                        Text("Privacy Policy")
                    }
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.gray)
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)
                .padding(.bottom, 50)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
        .toolbar(.hidden, for: .tabBar)
    }
}

#Preview {
    NavigationStack {
        SubscriptionPage()
    }
}
