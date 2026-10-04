//
//  OtpPage.swift
//  Levelio
//
//  Created by Irene Ancilla Chow on 21/05/26.
//

import SwiftUI

struct OtpPage: View {
    @Binding var activePage: AuthPage?
    @State private var otpText = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // --- 1. TOP NAVIGATION BAR ---
                HStack {
                    Button {
                        activePage = .forgotPassword
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                    .buttonStyle(.glassCircle)
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 50)
                .padding(.bottom, 12)
                
                // --- 2. SCROLLABLE FORM CONTENT ---
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 24) {
                        // Header Area
                        VStack(spacing: 12) {
                            Image("dino-curious")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 85)
                            
                            VStack(spacing: 4) {
                                Text("Verify Code")
                                    .font(.system(size: 28, weight: .heavy))
                                    .foregroundColor(.white)
                                
                                Text("Enter the 6-digit code sent to your email")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.gray.opacity(0.8))
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .padding(.top, 16)
                        
                        // OTP Input Fields with Backspace & Auto-fill support
                        ZStack {
                            // Hidden TextField overlay for capturing keyboard input & backspace
                            TextField("", text: $otpText)
                                .keyboardType(.numberPad)
                                .textContentType(.oneTimeCode)
                                .focused($isFocused)
                                .opacity(0.001)
                                .onChange(of: otpText) { _, newValue in
                                    let filtered = newValue.filter { $0.isNumber }
                                    if filtered.count > 6 {
                                        otpText = String(filtered.prefix(6))
                                    } else if filtered != newValue {
                                        otpText = filtered
                                    }
                                }
                            
                            // Visual 6-Digit Card Boxes
                            HStack(spacing: 8) {
                                ForEach(0..<6, id: \.self) { index in
                                    let digit = getDigit(at: index)
                                    let isCurrentFocus = isFocused && (index == otpText.count || (index == 5 && otpText.count == 6))
                                    
                                    Text(digit)
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 52)
                                        .background(Color.clear)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(isCurrentFocus ? Color.white : Color.white.opacity(0.4), lineWidth: 1.5)
                                        )
                                }
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            isFocused = true
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 16)
                }
                .scrollDismissesKeyboard(.interactively)
                
                Spacer(minLength: 10)
                
                // --- 3. BOTTOM STICKY ACTION BUTTONS ---
                VStack(spacing: 12) {
                    Button(action: {
                        print("Verify OTP: \(otpText)")
                    }) {
                        Text("Verify")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.white)
                            .cornerRadius(25)
                    }
                    
                    HStack(spacing: 4) {
                        Text("Didn’t receive any code?")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                        
                        Button(action: {
                            // Aksi resend
                        }) {
                            Text("Resend code")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color("secondary"))
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            hideKeyboard()
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            isFocused = true
        }
    }
    
    private func getDigit(at index: Int) -> String {
        guard index < otpText.count else { return "" }
        let stringIndex = otpText.index(otpText.startIndex, offsetBy: index)
        return String(otpText[stringIndex])
    }
}

#Preview {
    NavigationStack {
        OtpPage(activePage: .constant(.otp))
    }
}
