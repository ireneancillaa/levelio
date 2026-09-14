//
//  SignInPage.swift
//  Levelio
//
//  Created by Irene Ancilla Chow on 20/05/26.
//

import SwiftUI

struct SignInPage: View {
    @Binding var activePage: AuthPage?
    
    // Sinkronisasi status login global menggunakan penyimpanan internal iOS
    @AppStorage("isUserLoggedIn") private var isUserLoggedIn = false
    
    @State private var email = ""
    @State private var password = ""
    @State private var rememberMe = false
    @State private var isPasswordVisible = false
    
    // State penampung pesan error
    @State private var emailError: String? = nil
    @State private var passwordError: String? = nil
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    Spacer(minLength: 20)
                    
                    // 1. Header Area
                    VStack(spacing: 16) {
                        Image("dino-selfies")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 90)
                        
                        VStack(spacing: 4) {
                            Text("Welcome back")
                                .font(.system(size: 30, weight: .heavy))
                                .foregroundColor(.white)
                            
                            Text("Continue your journey to level up!")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.gray.opacity(0.8))
                        }
                    }
                    .padding(.bottom, 24)
                    
                    // 2. Form Input Area
                    VStack(spacing: 16) {
                        // Email Field
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Email")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                            
                            HStack(spacing: 12) {
                                Image(systemName: "envelope")
                                    .foregroundColor(emailError != nil ? .red : .gray)
                                    .frame(width: 24, alignment: .center)
                                
                                TextField("", text: $email, prompt: Text("Enter your email")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.gray)
                                )
                                .foregroundColor(.white)
                                .autocapitalization(.none)
                                .keyboardType(.emailAddress)
                                .onChange(of: email) {
                                    if emailError != nil { emailError = nil }
                                }
                            }
                            .padding()
                            .frame(height: 50)
                            .background(Color.clear)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(emailError != nil ? Color.red : Color.white.opacity(0.4), lineWidth: 1.5)
                            )
                            
                            if let emailError = emailError {
                                Text(emailError)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.red)
                                    .padding(.leading, 12)
                                    .transition(.opacity.combined(with: .move(edge: .top)))
                            }
                        }
                        
                        // Password Field
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Password")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                            
                            HStack(spacing: 12) {
                                Image(systemName: "lock")
                                    .foregroundColor(passwordError != nil ? .red : .gray)
                                    .frame(width: 24, alignment: .center)
                                
                                if isPasswordVisible {
                                    TextField("", text: $password, prompt: Text("Enter your password")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.gray)
                                    )
                                    .foregroundColor(.white)
                                    .onChange(of: password) {
                                        if passwordError != nil { passwordError = nil }
                                    }
                                } else {
                                    SecureField("", text: $password, prompt: Text("Enter your password")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.gray)
                                    )
                                    .foregroundColor(.white)
                                    .onChange(of: password) {
                                        if passwordError != nil { passwordError = nil }
                                    }
                                }
                                
                                Button(action: {
                                    isPasswordVisible.toggle()
                                }) {
                                    Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding()
                            .frame(height: 50)
                            .background(Color.clear)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(passwordError != nil ? Color.red : Color.white.opacity(0.4), lineWidth: 1.5)
                            )
                            
                            if let passwordError = passwordError {
                                Text(passwordError)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.red)
                                    .padding(.leading, 12)
                                    .transition(.opacity.combined(with: .move(edge: .top)))
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    // 3. Remember Me & Forgot Password Links
                    HStack {
                        Button(action: {
                            withAnimation(.easeIn(duration: 0.1)) {
                                rememberMe.toggle()
                            }
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: rememberMe ? "checkmark.square.fill" : "square")
                                    .font(.system(size: 18))
                                    .foregroundColor(rememberMe ? .gray : .white)
                                
                                Text("Remember me")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Spacer()
                        
                        Button(action: {
                            activePage = .forgotPassword
                        }) {
                            Text("Forgot Password?")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color("secondary"))
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                    .padding(.bottom, 24)
                    
                    // 4. Action Buttons
                    VStack(spacing: 10) {
                        Button(action: {
                            validateAndSignIn()
                        }) {
                            Text("Sign In")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.white)
                                .cornerRadius(25)
                        }
                        
                        // Teks Link Pindah Halaman ke Registrasi Akun
                        HStack(spacing: 4) {
                            Text("New to Levelio?")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                            
                            Button(action: { activePage = .signUp }) {
                                Text("Sign Up.")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(Color("secondary"))
                            }
                        }
                        .padding(.top, 10)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            }
            .safeAreaPadding(.top)
        }
    }
    
    // Fungsi Validasi & Autentikasi
    private func validateAndSignIn() {
        withAnimation(.easeInOut(duration: 0.2)) {
            var isValid = true
            
            // Validasi format email
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            
            if email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                emailError = "Email cannot be empty"
                isValid = false
            } else if !emailPredicate.evaluate(with: email) {
                emailError = "Please enter a valid email address"
                isValid = false
            } else {
                emailError = nil
            }
            
            // Validasi password
            if password.isEmpty {
                passwordError = "Password cannot be empty"
                isValid = false
            } else if password.count < 6 {
                passwordError = "Password must be at least 6 characters"
                isValid = false
            } else {
                passwordError = nil
            }
            
            // Eksekusi jika valid
            if isValid {
                withAnimation(.easeInOut(duration: 0.25)) {
                    isUserLoggedIn = true
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SignInPage(activePage: .constant(.signIn))
    }
}
