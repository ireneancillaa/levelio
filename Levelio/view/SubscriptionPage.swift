//
//  SubscriptionPage.swift
//  Levelio
//
//  Created by Irene Ancilla Chow on 30/05/26.
//

import SwiftUI

struct BenefitItem: Identifiable {
    let id = UUID()
    let iconName: String
    let title: String
    let description: String
    let accentColor: Color
}

struct SubscriptionPage: View {
    @Environment(\.dismiss) private var dismiss
    
    var isAdMode: Bool = false
    var onAdDismissed: (() -> Void)? = nil
    
    @State private var timeRemaining = 5
    @State private var selectedPlan = "Yearly" // "Yearly" or "Monthly"
    @State private var enableFreeTrial = true
    @State private var isPurchasing = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    // List Benefit Premium yang disempurnakan
    let benefits: [BenefitItem] = [
        BenefitItem(
            iconName: "infinity",
            title: "Unlimited Habits",
            description: "Build & track as many habits as you want without restrictions.",
            accentColor: Color("primary")
        ),
        BenefitItem(
            iconName: "chart.bar.xaxis",
            title: "Advanced Insights",
            description: "Deep analytics, streak trends, and completion statistics.",
            accentColor: Color.cyan
        ),
        BenefitItem(
            iconName: "sparkles",
            title: "Avatars & Streak Pets",
            description: "Hatch, customize & level up your exclusive Dino companions.",
            accentColor: Color("secondary")
        ),
        BenefitItem(
            iconName: "trophy.fill",
            title: "Exclusive Quests",
            description: "Unlock special community challenges & earn rare rewards.",
            accentColor: Color.yellow
        ),
        BenefitItem(
            iconName: "nosign",
            title: "100% Ad-Free",
            description: "Zero distractions. Focus 100% on achieving your goals.",
            accentColor: Color("tertiary")
        )
    ]
    
    var body: some View {
        ZStack {
            // Latar Belakang Gelap Khas Levelio
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                // --- 1. NAVIGATION TOP BAR WITH DISMISS BUTTON ---
                HStack {
                    // Counterbalance 36x36 agar judul badge tepat di tengah
                    Color.clear
                        .frame(width: 36, height: 36)
                    
                    Spacer()
                    
                    // Header Badge Title
                    HStack(spacing: 6) {
                        Text("✨ LEVELIO PREMIUM")
                            .font(.system(size: 11, weight: .black))
                            .tracking(1.2)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.white.opacity(0.08))
                            .overlay(
                                Capsule()
                                    .stroke(
                                        LinearGradient(
                                            colors: [Color("primary"), Color("secondary")],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        ),
                                        lineWidth: 1
                                    )
                            )
                    )
                    
                    Spacer()
                    
                    // Timer 5 detik (Ad mode) atau Tombol Tutup ('X' mark)
                    if isAdMode && timeRemaining > 0 {
                        HStack(spacing: 4) {
                            Text("\(timeRemaining)s")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(Color.white.opacity(0.08))
                                .overlay(Capsule().stroke(Color.white.opacity(0.2), lineWidth: 1))
                        )
                    } else {
                        Button {
                            dismiss()
                            onAdDismissed?()
                        } label: {
                            Image(systemName: "xmark")
                        }
                        .buttonStyle(.glassCircle)
                    }
                }
                .frame(height: 55)
                .padding(.horizontal, 24)
                .padding(.top, 50)
                .padding(.bottom, 20)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 24) {
                        
                        // --- 2. HERO CHARACTER ART & TYPOGRAPHY ---
                        VStack(spacing: 16) {
                            ZStack {
                                // Background Glow Aura
                                Circle()
                                    .fill(
                                        RadialGradient(
                                            colors: [Color("secondary").opacity(0.35), Color.clear],
                                            center: .center,
                                            startRadius: 20,
                                            endRadius: 90
                                        )
                                    )
                                    .frame(width: 180, height: 180)
                                
                                Image("dino-premium")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 145)
                                    .shadow(color: Color("secondary").opacity(0.5), radius: 20, x: 0, y: 10)
                            }
                            
                            VStack(spacing: 8) {
                                Text("Master Your Routine With Premium")
                                    .font(.system(size: 24, weight: .black))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                
                                Text("Level up faster, unlock powerful analytics, and achieve consistency effortlessly.")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(.white.opacity(0.7))
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(3)
                                    .padding(.horizontal, 16)
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.top, 4)
                        
                        // --- 3. PREMIUM BENEFITS SECTION (CARDS) ---
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Included With Premium")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.white.opacity(0.6))
                                .textCase(.uppercase)
                                .tracking(1)
                                .padding(.horizontal, 4)
                            
                            VStack(spacing: 10) {
                                ForEach(benefits) { benefit in
                                    HStack(spacing: 14) {
                                        // Custom Icon Badge
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(benefit.accentColor.opacity(0.15))
                                                .frame(width: 38, height: 38)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .stroke(benefit.accentColor.opacity(0.3), lineWidth: 1)
                                                )
                                            
                                            Image(systemName: benefit.iconName)
                                                .font(.system(size: 16, weight: .bold))
                                                .foregroundColor(benefit.accentColor)
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(benefit.title)
                                                .font(.system(size: 14, weight: .bold))
                                                .foregroundColor(.white)
                                            
                                            Text(benefit.description)
                                                .font(.system(size: 11, weight: .medium))
                                                .foregroundColor(.white.opacity(0.65))
                                                .lineLimit(2)
                                        }
                                        
                                        Spacer()
                                        
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(benefit.accentColor)
                                    }
                                    .padding(.all, 12)
                                    .background(Color.white.opacity(0.04))
                                    .cornerRadius(14)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14)
                                            .stroke(Color.white.opacity(0.08), lineWidth: 1)
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // --- 4. FREE TRIAL TOGGLE OPTION ---
                        HStack(spacing: 12) {
                            VStack(alignment: .leading, spacing: 3) {
                                HStack(spacing: 6) {
                                    Text("7-Day Free Trial Included")
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                    Text("RISK-FREE")
                                        .font(.system(size: 9, weight: .black))
                                        .foregroundColor(.black)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(Color.yellow)
                                        .cornerRadius(4)
                                }
                                
                                Text("Try all premium features for 7 days free. Cancel anytime.")
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(.white.opacity(0.65))
                            }
                            
                            Spacer()
                            
                            Toggle("", isOn: $enableFreeTrial)
                                .labelsHidden()
                                .tint(Color("secondary"))
                        }
                        .padding(.all, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color("primary").opacity(0.1))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color("primary").opacity(0.3), lineWidth: 1)
                        )
                        .padding(.horizontal, 20)
                        
                        // --- 5. CHOOSE YOUR PLAN SECTION ---
                        VStack(spacing: 14) {
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
                                
                                Rectangle()
                                    .fill(LinearGradient(colors: [.white.opacity(0.2), .clear], startPoint: .leading, endPoint: .trailing))
                                    .frame(height: 1)
                            }
                            .padding(.horizontal, 20)
                            
                            // Plan Selector Grid (Monthly vs Yearly)
                            HStack(spacing: 14) {
                                // PLAN 1: MONTHLY
                                Button(action: { selectedPlan = "Monthly" }) {
                                    VStack(spacing: 6) {
                                        HStack {
                                            Spacer()
                                            ZStack {
                                                Circle()
                                                    .fill(selectedPlan == "Monthly" ? Color("secondary") : Color.white.opacity(0.1))
                                                    .frame(width: 18, height: 18)
                                                if selectedPlan == "Monthly" {
                                                    Image(systemName: "checkmark")
                                                        .font(.system(size: 10, weight: .bold))
                                                        .foregroundColor(.white)
                                                }
                                            }
                                        }
                                        
                                        VStack(spacing: 2) {
                                            Text("Pay Monthly")
                                                .font(.system(size: 13, weight: .bold))
                                                .foregroundColor(.white)
                                            
                                            HStack(alignment: .firstTextBaseline, spacing: 2) {
                                                Text("$3.99")
                                                    .font(.system(size: 24, weight: .black))
                                                    .foregroundColor(.white)
                                                Text("/mo")
                                                    .font(.system(size: 11, weight: .semibold))
                                                    .foregroundColor(.gray)
                                            }
                                            
                                            Text("Billed monthly")
                                                .font(.system(size: 10, weight: .medium))
                                                .foregroundColor(.gray)
                                        }
                                        .padding(.bottom, 6)
                                    }
                                    .padding(.all, 12)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 115)
                                    .background(selectedPlan == "Monthly" ? Color.white.opacity(0.08) : Color.white.opacity(0.03))
                                    .cornerRadius(16)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .strokeBorder(
                                                selectedPlan == "Monthly" ?
                                                LinearGradient(
                                                    colors: [Color("primary"), Color("secondary"), Color("tertiary")],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                ) :
                                                LinearGradient(colors: [Color.white.opacity(0.08)], startPoint: .leading, endPoint: .trailing),
                                                lineWidth: selectedPlan == "Monthly" ? 2 : 1
                                            )
                                    )
                                }
                                
                                // PLAN 2: YEARLY (WITH SAVE BADGE & GLOW)
                                Button(action: { selectedPlan = "Yearly" }) {
                                    ZStack(alignment: .top) {
                                        VStack(spacing: 6) {
                                            HStack {
                                                Spacer()
                                                ZStack {
                                                    Circle()
                                                        .fill(selectedPlan == "Yearly" ? Color("secondary") : Color.white.opacity(0.1))
                                                        .frame(width: 18, height: 18)
                                                    if selectedPlan == "Yearly" {
                                                        Image(systemName: "checkmark")
                                                            .font(.system(size: 10, weight: .bold))
                                                            .foregroundColor(.white)
                                                    }
                                                }
                                            }
                                            
                                            VStack(spacing: 2) {
                                                Text("Pay Yearly")
                                                    .font(.system(size: 13, weight: .bold))
                                                    .foregroundColor(.white)
                                                
                                                HStack(alignment: .firstTextBaseline, spacing: 2) {
                                                    Text("$29.99")
                                                        .font(.system(size: 24, weight: .black))
                                                        .foregroundColor(.white)
                                                    Text("/yr")
                                                        .font(.system(size: 11, weight: .semibold))
                                                        .foregroundColor(.gray)
                                                }
                                                
                                                Text("$2.50/mo (Save 37%)")
                                                    .font(.system(size: 10, weight: .semibold))
                                                    .foregroundColor(Color.green)
                                            }
                                            .padding(.bottom, 6)
                                        }
                                        .padding(.all, 12)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 115)
                                        .background(selectedPlan == "Yearly" ? Color.white.opacity(0.1) : Color.white.opacity(0.04))
                                        .cornerRadius(16)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .strokeBorder(
                                                    selectedPlan == "Yearly" ?
                                                    LinearGradient(
                                                        colors: [Color("tertiary"), Color("secondary"), Color("primary")],
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    ) :
                                                    LinearGradient(colors: [Color.white.opacity(0.08)], startPoint: .leading, endPoint: .trailing),
                                                    lineWidth: selectedPlan == "Yearly" ? 2 : 1
                                                )
                                                .shadow(
                                                    color: selectedPlan == "Yearly" ? Color("secondary").opacity(0.4) : .clear,
                                                    radius: 12
                                                )
                                        )
                                        
                                        // Floating Best Value Badge
                                        Text("SAVE 37% 🔥")
                                            .font(.system(size: 10, weight: .heavy))
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 4)
                                            .background(
                                                LinearGradient(
                                                    colors: [Color("tertiary"), Color("secondary"), Color("primary")],
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                            .cornerRadius(10)
                                            .offset(y: -11)
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        // --- 6. SOCIAL PROOF & RATING ---
                        HStack(spacing: 8) {
                            Text("⭐️⭐️⭐️⭐️⭐️")
                                .font(.system(size: 12))
                            Text("4.9/5 rated by 10,000+ habit builders")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .padding(.top, 4)
                    }
                    .padding(.bottom, 24)
                }
                
                // --- 7. FIXED BOTTOM CTA & LEGAL ---
                VStack(spacing: 10) {
                    Button(action: {
                        handleSubscribeAction()
                    }) {
                        HStack(spacing: 8) {
                            if isPurchasing {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Image(systemName: "bolt.fill")
                                    .font(.system(size: 14))
                                    .foregroundColor(.yellow)
                                
                                Text(
                                    enableFreeTrial ? "Start 7-Day Free Trial" : (
                                        selectedPlan == "Yearly" ? "Subscribe for $29.99 / Year" : "Subscribe for $3.99 / Month"
                                    )
                                )
                                .font(.system(size: 16, weight: .black))
                                .foregroundColor(.white)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(
                            LinearGradient(
                                colors: [Color("tertiary"), Color("secondary"), Color("primary")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(26)
                        .shadow(color: Color("secondary").opacity(0.5), radius: 15, x: 0, y: 6)
                    }
                    .disabled(isPurchasing)
                    
                    // Subtitle billing details
                    Text(
                        enableFreeTrial
                        ? "7 days free, then \(selectedPlan == "Yearly" ? "$29.99/yr ($2.50/mo)" : "$3.99/mo"). Cancel anytime."
                        : "Billed \(selectedPlan == "Yearly" ? "$29.99 annually" : "$3.99 monthly"). Cancel anytime."
                    )
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
                    
                    // Legal Terms links + Restore Purchases
                    HStack(spacing: 12) {
                        Button("Restore Purchases") {
                            alertMessage = "Your previous purchases have been restored successfully!"
                            showAlert = true
                        }
                        
                        Text("•")
                        
                        Button("Terms of Service") {
                            alertMessage = "Levelio Terms of Service: Premium subscriptions automatically renew unless canceled at least 24 hours before the end of the current period."
                            showAlert = true
                        }
                        
                        Text("•")
                        
                        Button("Privacy Policy") {
                            alertMessage = "Levelio Privacy Policy: We respect your privacy. Your data is encrypted and secure."
                            showAlert = true
                        }
                    }
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.gray)
                    .padding(.top, 4)
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 36)
                .background(
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                )
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .toolbarBackground(.hidden, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
        .toolbar(.hidden, for: .tabBar)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Levelio Premium"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK")) {
                    if alertMessage.contains("active") {
                        dismiss()
                    }
                }
            )
        }
        .task {
            if isAdMode {
                timeRemaining = 5
                while timeRemaining > 0 {
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                    if timeRemaining > 0 {
                        timeRemaining -= 1
                    }
                }
            }
        }
    }
    
    private func handleSubscribeAction() {
        isPurchasing = true
        
        // Simulasikan delay transaksi In-App Purchase
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            isPurchasing = false
            alertMessage = "Welcome to Levelio Premium! 🚀\nYour subscription is now active."
            showAlert = true
        }
    }
}

#Preview {
    NavigationStack {
        SubscriptionPage()
    }
}
