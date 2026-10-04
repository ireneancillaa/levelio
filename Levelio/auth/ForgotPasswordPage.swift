//
//  ForgotPasswordPage.swift
//  Levelio
//
//  Created by Irene Ancilla Chow on 21/05/26.
//

import SwiftUI

struct ForgotPasswordPage: View {
    @Binding var activePage: AuthPage?
    @State private var email = ""
    
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
                        activePage = .signIn
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
                                Text("Forgot Password")
                                    .font(.system(size: 28, weight: .heavy))
                                    .foregroundColor(.white)
                                Text("Enter your email to receive a reset link")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.gray.opacity(0.8))
                            }
                        }
                        .padding(.top, 16)
                        
                        // Email Field
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Email")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                            
                            HStack(spacing: 12) {
                                Image(systemName: "envelope")
                                    .foregroundColor(.gray)
                                    .frame(width: 24, alignment: .center)
                                
                                TextField("", text: $email, prompt: Text("Enter your email")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.gray)
                                )
                                .foregroundColor(.white)
                                .autocapitalization(.none)
                                .keyboardType(.emailAddress)
                            }
                            .padding()
                            .frame(height: 50)
                            .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.white.opacity(0.4), lineWidth: 1.5))
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 16)
                }
                .scrollDismissesKeyboard(.interactively)
                
                Spacer(minLength: 10)
                
                // --- 3. BOTTOM STICKY ACTION BUTTON ---
                Button(action: {
                    activePage = .otp
                }) {
                    Text("Send")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.white)
                        .cornerRadius(25)
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
    }
}

#Preview {
    NavigationStack {
        ForgotPasswordPage(activePage: .constant(.forgotPassword))
    }
}
