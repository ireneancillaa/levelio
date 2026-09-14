//
//  TermsAndConditionsPage.swift
//  Levelio
//
//  Created by Irene Ancilla Chow on 21/05/26.
//

import SwiftUI

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct TermsAndConditionsPage: View {
    @Binding var activePage: AuthPage?
    @Binding var isAccepted: Bool
    
    @State private var hasScrolledToBottom = false
    @State private var isAutoScrollEnabled = false
    @State private var isCheckboxChecked = false
    
    // Data Struktur untuk Section T&C
    struct TermSection: Identifiable {
        let id = UUID()
        let icon: String
        let title: String
        let content: String
    }
    
    let sections: [TermSection] = [
        TermSection(
            icon: "person.badge.key.fill",
            title: "1. Account Responsibility & Security",
            content: "You are responsible for safeguarding your personal data, level logs, and achievement sync history inside Levelio. Any unauthorized use of your account must be reported immediately to the support team. Levelio cannot and will not be liable for any loss or damage arising from your failure to comply with these security obligations."
        ),
        TermSection(
            icon: "gamecontroller.fill",
            title: "2. Gamification & Fair Play Rules",
            content: "Any unfair methods, third-party modifications, botting, or system exploits used to manipulate user levels, streak counters, task timers, or dino rewards are strictly prohibited. Continuous manipulation of the gamification mechanics compromises the experience for the entire community and may result in account restrictions."
        ),
        TermSection(
            icon: "lock.shield.fill",
            title: "3. Data Privacy & Protection Policy",
            content: "We care deeply about your privacy. Levelio stores your local preferences and uses secure synchronization protocols. Your personal goal data, daily logs, and habit routines will never be traded, sold, or shared with unverified external parties without your explicit consent."
        ),
        TermSection(
            icon: "paintpalette.fill",
            title: "4. Intellectual Property Rights",
            content: "All custom graphics, illustrations, dino character designs, user interface layouts, software code, and brand assets contained within Levelio are the exclusive property of Levelio and its creators. Unauthorized reproduction or distribution is strictly prohibited."
        ),
        TermSection(
            icon: "scalemass.fill",
            title: "5. Limitation of Liability",
            content: "Levelio is provided on an 'as-is' and 'as-available' basis. We strive for maximum reliability but do not guarantee that the application will be error-free at all times. Levelio shall not be liable for any indirect or incidental damages resulting from your use of the service."
        ),
        TermSection(
            icon: "arrow.triangle.2.circlepath",
            title: "6. Content Updates & Terms Modification",
            content: "Levelio reserves the right to update features, interface designs, reward thresholds, and terms periodically to improve user experience. Continued use of the application after updates constitutes acceptance of the modified terms."
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
                
                // --- 1. TOP NAVIGATION BAR ---
                ZStack {
                    HStack {
                        Button(action: {
                            activePage = .signUp
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 16, weight: .bold))
                                Text("Back")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundColor(.white)
                        }
                        Spacer()
                    }
                    
                    Text("Terms of Service")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 24)
                .padding(.top, 50)
                .padding(.bottom, 16)
                
                // --- 2. MAIN SCROLLABLE CONTENT ---
                ScrollViewReader { proxy in
                    ScrollView(.vertical, showsIndicators: true) {
                        VStack(alignment: .leading, spacing: 18) {
                            
                            // HERO HEADER
                            VStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(Color.cyan.opacity(0.15))
                                        .frame(width: 90, height: 90)
                                        .blur(radius: 10)
                                    
                                    Image("dino-book")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 90)
                                }
                                
                                Text("Terms & Conditions")
                                    .font(.system(size: 26, weight: .heavy))
                                    .foregroundColor(.white)
                                
                                Text("Please read and accept our community guidelines to level up your habits.")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 12)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 6)
                            
                            // QUICK HIGHLIGHTS BOX (AT A GLANCE)
                            VStack(alignment: .leading, spacing: 10) {
                                HStack(spacing: 6) {
                                    Image(systemName: "sparkles")
                                        .foregroundColor(.cyan)
                                    Text("AT A GLANCE")
                                        .font(.system(size: 12, weight: .black))
                                        .foregroundColor(.cyan)
                                }
                                
                                HStack(spacing: 8) {
                                    HighlightPill(icon: "shield.fill", text: "Fair Play")
                                    HighlightPill(icon: "lock.fill", text: "Private Data")
                                    HighlightPill(icon: "star.fill", text: "XP Rewards")
                                }
                            }
                            .padding(.all, 14)
                            .background(Color.white.opacity(0.04))
                            .cornerRadius(14)
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.1), lineWidth: 1))
                            
                            // SECTION CARDS DOKUMEN HUKUM
                            ForEach(sections) { sec in
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack(spacing: 10) {
                                        Image(systemName: sec.icon)
                                            .font(.system(size: 15, weight: .bold))
                                            .foregroundColor(.cyan)
                                            .frame(width: 28, height: 28)
                                            .background(Color.cyan.opacity(0.15))
                                            .cornerRadius(8)
                                        
                                        Text(sec.title)
                                            .font(.system(size: 15, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                    
                                    Text(sec.content)
                                        .font(.system(size: 13, weight: .regular))
                                        .foregroundColor(.white.opacity(0.8))
                                        .lineSpacing(4)
                                }
                                .padding(.all, 16)
                                .background(Color.white.opacity(0.04))
                                .cornerRadius(14)
                                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.08), lineWidth: 1))
                            }
                            
                            // CALLOUT NOTICE AT BOTTOM
                            HStack(spacing: 12) {
                                Image(systemName: "info.circle.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(.cyan)
                                
                                Text("By accepting, you agree to build positive habits consistently and respect Levelio's community standards.")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(.white.opacity(0.9))
                            }
                            .padding(.all, 14)
                            .background(Color.cyan.opacity(0.1))
                            .cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.cyan.opacity(0.3), lineWidth: 1))
                            
                            // Scroll Bottom Marker
                            GeometryReader { geo in
                                Color.clear
                                    .preference(
                                        key: ScrollOffsetPreferenceKey.self,
                                        value: geo.frame(in: .named("scrollSpace")).maxY
                                    )
                            }
                            .frame(height: 1)
                            .id("bottomMarker")
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 20)
                    }
                    .coordinateSpace(name: "scrollSpace")
                    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { maxY in
                        if maxY < 750 && !hasScrolledToBottom {
                            withAnimation {
                                hasScrolledToBottom = true
                                isCheckboxChecked = true
                            }
                        }
                    }
                    .onChange(of: isAutoScrollEnabled) { _, newValue in
                        if newValue {
                            withAnimation(.easeInOut(duration: 3.0)) {
                                proxy.scrollTo("bottomMarker", anchor: .bottom)
                            }
                        }
                    }
                }
                
                // --- 3. BOTTOM CONSENT & ACTION BAR ---
                VStack(spacing: 14) {
                    
                    // Auto Scroll Toggle & Status Indicator
                    HStack {
                        Toggle(isOn: $isAutoScrollEnabled) {
                            HStack(spacing: 6) {
                                Image(systemName: "arrow.down.circle.fill")
                                    .font(.system(size: 14))
                                    .foregroundColor(.cyan)
                                Text("Auto scroll to bottom")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .cyan))
                    }
                    .padding(.horizontal, 4)
                    
                    // Agreement Checkbox
                    Button(action: {
                        isCheckboxChecked.toggle()
                    }) {
                        HStack(spacing: 10) {
                            Image(systemName: isCheckboxChecked ? "checkmark.square.fill" : "square")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(isCheckboxChecked ? Color("secondary") : .white.opacity(0.4))
                            
                            Text("I have read and agree to the Terms & Conditions")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.white)
                            
                            Spacer()
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    // Action Buttons
                    HStack(spacing: 12) {
                        Button(action: {
                            activePage = .signUp
                        }) {
                            Text("Decline")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.white.opacity(0.7))
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(25)
                        }
                        
                        Button(action: {
                            isAccepted = true
                            UserDefaults.standard.set(true, forKey: "hasAcceptedTerms")
                            activePage = .signUp
                        }) {
                            Text("Accept & Continue")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor((isCheckboxChecked || hasScrolledToBottom) ? .black : .white.opacity(0.3))
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background((isCheckboxChecked || hasScrolledToBottom) ? Color.white : Color.white.opacity(0.15))
                                .cornerRadius(25)
                        }
                        .disabled(!isCheckboxChecked && !hasScrolledToBottom)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 14)
                .padding(.bottom, 40)
                .background(
                    Color.black.opacity(0.3)
                        .blur(radius: 10)
                        .ignoresSafeArea(edges: .bottom)
                )
            }
            .safeAreaPadding(.top)
        }
        .navigationBarBackButtonHidden(true)
    }
}

// Subview Pill untuk Quick Highlights (At a Glance)
struct HighlightPill: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(.cyan)
            Text(text)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.06))
        .cornerRadius(10)
    }
}

#Preview {
    NavigationStack {
        TermsAndConditionsPage(activePage: .constant(.tnc), isAccepted: .constant(false))
    }
}
