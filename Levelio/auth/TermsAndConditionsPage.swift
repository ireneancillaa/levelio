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
    
    var body: some View {
        ZStack {
            // 1. Latar Belakang Gelap Konstan
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 60)
                
                VStack(spacing: 20) {
                    Image("dino-book")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                    
                    VStack(spacing: 5) {
                        Text("Terms & Conditions")
                            .font(.system(size: 32, weight: .heavy))
                            .foregroundColor(.white)
                        
                        Text("Please read and accept our rules to continue")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.gray.opacity(0.8))
                    }
                    .padding(.bottom, 25)
                }
                ScrollViewReader { proxy in
                    ScrollView(.vertical, showsIndicators: true) {
                        VStack(alignment: .leading, spacing: 5) {
                            
                            Text("Welcome to Levelio!")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("By creating an account and using this application, you agree to build positive small habits, maintain your daily streaks, and push your personal growth boundaries everyday. Please read these terms carefully before proceeding.")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray.opacity(0.9))
                                .padding(.bottom, 5)
                            
                            Text("1. Account Responsibility")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Text("You are responsible for safeguarding your personal data, level logs, and achievement sync history inside Levelio. Any unauthorized use of your account must be reported immediately to the support team. Levelio cannot and will not be liable for any loss or damage arising from your failure to comply with these security obligations.")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray.opacity(0.9))
                                .padding(.bottom, 5)
                            
                            Text("2. Gamification & Fair Play Rules")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Text("Any unfair methods, third-party modifications, botting, or system exploits used to manipulate user levels, streak counters, task timers, or dino rewards are highly discouraged. Continuous manipulation of the gamification mechanics compromises the experience for the entire community and may result in temporary or permanent account restrictions.")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray.opacity(0.9))
                                .padding(.bottom, 5)
                            
                            Text("3. Data Privacy Policy")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Text("We care about your privacy. Levelio stores your local preferences and uses secure synchronization protocols. Your personal goal data, daily logs, and habit routines will never be traded, sold, or shared with unverified external parties without explicit user consent. For more details, please review our comprehensive Privacy Policy section.")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray.opacity(0.9))
                                .padding(.bottom, 5)
                            
                            Text("4. Intellectual Property Rights")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Text("All custom graphics, illustrations, dino character designs, user interface layouts, software code, and brand assets contained within Levelio are the exclusive property of Levelio and its creators. Unauthorized reproduction, distribution, or modification of these assets is strictly prohibited.")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray.opacity(0.9))
                                .padding(.bottom, 5)
                            
                            Text("5. Limitation of Liability")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Text("Levelio is provided on an 'as-is' and 'as-available' basis. We do not guarantee that the application will be completely error-free or uninterrupted at all times. In no event shall Levelio be liable for any indirect, incidental, or consequential damages resulting from your use or inability to use the service.")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray.opacity(0.9))
                                .padding(.bottom, 5)
                            
                            Text("6. Content Updates & Service Changes")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Text("Levelio reserves the right to update features, interface designs, reward thresholds, and habit-tracking engines periodically to improve user experience. Continuous violation of our fair-play or safety guidelines may lead to access termination without prior notice.")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray.opacity(0.9))
                            
                            // Penanda Akhir Dokumen
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
                        .padding(.all, 18) // Mengatur padding teks di dalam box agar lebih rapi
                    }
                    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { maxY in
                        // Menggunakan toleransi dinamis (bila posisi maxY sudah mendekati area bawah box)
                        if maxY < 580 && !hasScrolledToBottom {
                            withAnimation {
                                hasScrolledToBottom = true
                            }
                        }
                    }
                    .onChange(of: isAutoScrollEnabled) { _, newValue in
                        if newValue {
                            withAnimation(.easeInOut(duration: 3.5)) {
                                proxy.scrollTo("bottomMarker", anchor: .bottom)
                            }
                        }
                    }
                }
                .coordinateSpace(name: "scrollSpace")
                .background(Color.white.opacity(0.05))
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.15), lineWidth: 1.2)
                )
                .padding(.horizontal, 24)
                
                // 4. Baris Saklar Fitur Auto-Scroll
                Toggle(isOn: $isAutoScrollEnabled) {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.down.doc.fill")
                            .font(.system(size: 13))
                        Text("Auto scroll to bottom")
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .foregroundColor(.gray.opacity(0.9))
                }
                .toggleStyle(SwitchToggleStyle(tint: Color("secondary")))
                .padding(.horizontal, 28)
                .padding(.top, 16)
                
                Spacer()
                    .frame(height: 25)
                
                // 5. Tombol Aksi "Accept"
                VStack {
                    Button(action: {
                        isAccepted = true
                        UserDefaults.standard.set(true, forKey: "hasAcceptedTerms")
                        activePage = .signUp
                    }) {
                        Text("Accept and Continue")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(hasScrolledToBottom ? .black : .white.opacity(0.3))
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(hasScrolledToBottom ? Color.white : Color.white.opacity(0.15))
                            .cornerRadius(25)
                    }
                    .disabled(!hasScrolledToBottom)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 60)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    activePage = .signUp
                }) {
                    HStack(spacing: 5) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17, weight: .semibold))
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        TermsAndConditionsPage(activePage: .constant(.tnc), isAccepted: .constant(false))
    }
}
