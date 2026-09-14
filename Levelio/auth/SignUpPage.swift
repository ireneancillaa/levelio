//
//  SignUpPage.swift
//  Levelio
//
//  Created by Irene Ancilla Chow on 20/05/26.
//

import SwiftUI

struct FilesUserDefaultsHelper {
    static func getTermsStatus() -> Bool {
        return UserDefaults.standard.bool(forKey: "hasAcceptedTerms")
    }
}

struct SignUpPage: View {
    @Binding var activePage: AuthPage?
    
    // Sinkronisasi status login global aplikasi
    @AppStorage("isUserLoggedIn") private var isUserLoggedIn = false
    
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isAccepted = false
    @State private var isPasswordVisible = false
    @State private var isConfirmPasswordVisible = false
    
    // State penampung pesan error
    @State private var fullNameError: String? = nil
    @State private var emailError: String? = nil
    @State private var passwordError: String? = nil
    @State private var confirmPasswordError: String? = nil
    @State private var termsError: String? = nil
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 60)
                
                // 1. Header Area
                VStack(spacing: 20) {
                    Image("dino-selfies")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                    
                    VStack(spacing: 5) {
                        Text("Create Account")
                            .font(.system(size: 32, weight: .heavy))
                            .foregroundColor(.white)
                        
                        Text("Join us to start your journey!")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.gray.opacity(0.8))
                    }
                }
                .padding(.bottom, 24)
                
                // 2. Form Input Fields
                VStack(spacing: 14) {
                    // Full Name
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Full Name")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                        
                        HStack(spacing: 12) {
                            Image(systemName: "person")
                                .foregroundColor(fullNameError != nil ? .red : .gray)
                                .frame(width: 24, alignment: .center)
                            
                            TextField("", text: $fullName, prompt: Text("Enter your full name")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.gray)
                            )
                            .foregroundColor(.white)
                            .autocapitalization(.words)
                            .onChange(of: fullName) {
                                if fullNameError != nil { fullNameError = nil }
                            }
                        }
                        .padding()
                        .frame(height: 50)
                        .background(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(fullNameError != nil ? Color.red : Color.white.opacity(0.4), lineWidth: 1.5)
                        )
                        
                        if let fullNameError = fullNameError {
                            Text(fullNameError)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.red)
                                .padding(.leading, 12)
                                .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                    }
                    
                    // Email
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
                    
                    // Password
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
                            
                            Button(action: { isPasswordVisible.toggle() }) {
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
                    
                    // Confirm Password
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Confirm Password")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                        
                        HStack(spacing: 12) {
                            Image(systemName: "lock")
                                .foregroundColor(confirmPasswordError != nil ? .red : .gray)
                                .frame(width: 24, alignment: .center)
                            
                            if isConfirmPasswordVisible {
                                TextField("", text: $confirmPassword, prompt: Text("Confirm your password")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.gray)
                                )
                                .foregroundColor(.white)
                                .onChange(of: confirmPassword) {
                                    if confirmPasswordError != nil { confirmPasswordError = nil }
                                }
                            } else {
                                SecureField("", text: $confirmPassword, prompt: Text("Confirm your password")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.gray)
                                )
                                .foregroundColor(.white)
                                .onChange(of: confirmPassword) {
                                    if confirmPasswordError != nil { confirmPasswordError = nil }
                                }
                            }
                            
                            Button(action: { isConfirmPasswordVisible.toggle() }) {
                                Image(systemName: isConfirmPasswordVisible ? "eye" : "eye.slash")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .frame(height: 50)
                        .background(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(confirmPasswordError != nil ? Color.red : Color.white.opacity(0.4), lineWidth: 1.5)
                        )
                        
                        if let confirmPasswordError = confirmPasswordError {
                            Text(confirmPasswordError)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.red)
                                .padding(.leading, 12)
                                .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                    }
                }
                .padding(.horizontal, 24)
                
                // 3. Terms & Conditions Checkbox Row
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Button(action: {
                            withAnimation(.easeIn(duration: 0.1)) {
                                isAccepted.toggle()
                                if isAccepted { termsError = nil }
                                UserDefaults.standard.set(isAccepted, forKey: "hasAcceptedTerms")
                            }
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: isAccepted ? "checkmark.square.fill" : "square")
                                    .font(.system(size: 16))
                                    .foregroundColor(isAccepted ? Color("secondary") : (termsError != nil ? .red : .white))
                                
                                HStack(spacing: 4) {
                                    Text("I agree to")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.white)
                                    
                                    Button(action: {
                                        activePage = .tnc
                                    }) {
                                        Text("Terms and Conditions")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(Color("secondary"))
                                            .underline()
                                    }
                                }
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Spacer()
                    }
                    
                    if let termsError = termsError {
                        Text(termsError)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.red)
                            .padding(.leading, 24)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 14)
                
                Spacer()
                
                // 4. Action Buttons
                VStack(spacing: 10) {
                    Button(action: {
                        validateAndSignUp()
                    }) {
                        Text("Sign Up")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.white)
                            .cornerRadius(25)
                    }
                    
                    // Garis pembatas linear 'or'
                    HStack(spacing: 16) {
                        Rectangle()
                            .fill(Color.white.opacity(0.2))
                            .frame(height: 1)
                        
                        Text("or")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Rectangle()
                            .fill(Color.white.opacity(0.2))
                            .frame(height: 1)
                    }
                    .padding(.horizontal, 5)
                    
                    // Tombol Google OAuth Signup
                    Button(action: {
                        // Jalankan Google OAuth
                    }) {
                        HStack(spacing: 12) {
                            Image("google-logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                            
                            Text("Continue with Google")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.white.opacity(0.4), lineWidth: 1.5)
                        )
                    }
                    
                    // Link navigasi kembali ke halaman masuk (Sign In)
                    HStack(spacing: 4) {
                        Text("Already have an account?")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                        
                        Button(action: { activePage = .signIn }) {
                            Text("Sign In.")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color("secondary"))
                        }
                    }
                    .padding(.top, 10)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 70)
            }
        }
        .onAppear {
            isAccepted = FilesUserDefaultsHelper.getTermsStatus()
        }
    }
    
    // Fungsi Validasi & Pendaftaran Akun
    private func validateAndSignUp() {
        withAnimation(.easeInOut(duration: 0.2)) {
            var isValid = true
            
            // 1. Validasi Nama Lengkap
            if fullName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                fullNameError = "Full name cannot be empty"
                isValid = false
            } else {
                fullNameError = nil
            }
            
            // 2. Validasi Format Email
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
            
            // 3. Validasi Password
            if password.isEmpty {
                passwordError = "Password cannot be empty"
                isValid = false
            } else if password.count < 6 {
                passwordError = "Password must be at least 6 characters"
                isValid = false
            } else {
                passwordError = nil
            }
            
            // 4. Validasi Confirm Password
            if confirmPassword.isEmpty {
                confirmPasswordError = "Please confirm your password"
                isValid = false
            } else if confirmPassword != password {
                confirmPasswordError = "Passwords do not match"
                isValid = false
            } else {
                confirmPasswordError = nil
            }
            
            // 5. Validasi Persetujuan Syarat & Ketentuan
            if !isAccepted {
                termsError = "You must agree to the Terms and Conditions"
                isValid = false
            } else {
                termsError = nil
            }
            
            // Eksekusi jika seluruh form valid
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
        SignUpPage(activePage: .constant(.signUp))
    }
}
