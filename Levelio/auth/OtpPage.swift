//
//  OtpPage.swift
//  Levelio
//
//  Created by Irene Ancilla Chow on 21/05/26.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct OtpPage: View {
    @Binding var activePage: AuthPage?
    @State private var otpDigits: [String] = Array(repeating: "", count: 6)
    @FocusState private var focusedField: Int?
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .onTapGesture {
                    hideKeyboard()
                }
            
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 60)
                
                VStack(spacing: 20) {
                    Image("dino-curious")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                    
                    VStack(spacing: 5) {
                        Text("Verify Code")
                            .font(.system(size: 32, weight: .heavy))
                            .foregroundColor(.white)
                        
                        Text("Enter the 6-digit code sent to your email")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.gray.opacity(0.8))
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.bottom, 30)
                
                HStack(spacing: 12) {
                    ForEach(0..<6, id: \.self) { index in
                        TextField("", text: $otpDigits[index])
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .keyboardType(.numberPad)
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                            .background(Color.clear)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(focusedField == index ? Color.white : Color.white.opacity(0.4), lineWidth: 1.5)
                            )
                            .contentShape(Rectangle())
                            .onTapGesture {
                                focusedField = index
                            }
                            .focused($focusedField, equals: index)
                            .onChange(of: otpDigits[index]) { oldValue, newValue in
                                // Keep focus on current field when deleting; do not jump to previous box
                                if newValue.isEmpty {
                                    // Do nothing; stay focused on the same index
                                    return
                                }

                                // Ensure only 1 numeric character in each box
                                // 1) Filter non-digits
                                let filtered = newValue.filter { $0.isNumber }
                                if filtered != newValue {
                                    otpDigits[index] = filtered
                                }

                                // 2) Keep only the last digit if user pasted/typed multiple
                                if otpDigits[index].count > 1 {
                                    otpDigits[index] = String(otpDigits[index].last!)
                                }

                                // Auto-advance to next box only when user entered a digit and next is empty
                                if index < 5, !otpDigits[index].isEmpty {
                                    let nextIsEmpty = otpDigits[index + 1].isEmpty
                                    if nextIsEmpty {
                                        focusedField = index + 1
                                    }
                                }
                            }
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
                
                VStack(spacing: 20) {
                    Button(action: {
                        let fullCode = otpDigits.joined()
                        print("Verify OTP: \(fullCode)")
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
                .padding(.bottom, 70)
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .contentShape(Rectangle())
            .onTapGesture {
                hideKeyboard()
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    activePage = .forgotPassword
                }) {
                    HStack(spacing: 5) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17, weight: .semibold))
                    }
                    .foregroundColor(.white)
                }
            }
        }
        .onAppear {
            focusedField = 0
        }
    }
}

#Preview {
    NavigationStack {
        OtpPage(activePage: .constant(.otp))
    }
}
