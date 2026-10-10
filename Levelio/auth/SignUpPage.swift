//
//  SignUpPage.swift
//  Levelio
//
//  Created by Irene Ancilla Chow on 20/05/26.
//

import SwiftUI
import Foundation

struct FilesUserDefaultsHelper {
    static func getTermsStatus() -> Bool {
        return UserDefaults.standard.bool(forKey: "hasAcceptedTerms")
    }
    
    static func setTermsStatus(_ accepted: Bool) {
        UserDefaults.standard.set(accepted, forKey: "hasAcceptedTerms")
    }
}

struct SignUpPage: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var activePage: AuthPage?
    
    // Sinkronisasi status login global aplikasi
    @AppStorage("isUserLoggedIn") private var isUserLoggedIn = false
    @AppStorage("currentUserId") private var currentUserId = ""
    
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
                // Top Scrollable Area for Header & Form
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        Spacer(minLength: 12)
                        
                        // 1. Header Area
                        VStack(spacing: 12) {
                            Image("dino-selfies")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 85)
                            
                            VStack(spacing: 4) {
                                Text("Create Account")
                                    .font(.system(size: 28, weight: .heavy))
                                    .foregroundColor(.white)
                                
                                Text("Join us to start your journey!")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.gray.opacity(0.8))
                            }
                        }
                        .padding(.top, 28)
                        
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
                            
                            // Confirm Password Field
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Confirm Password")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                HStack(spacing: 12) {
                                    Image(systemName: "lock.shield")
                                        .foregroundColor(confirmPasswordError != nil ? .red : .gray)
                                        .frame(width: 24, alignment: .center)
                                    
                                    if isConfirmPasswordVisible {
                                        TextField("", text: $confirmPassword, prompt: Text("Re-enter your password")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(.gray)
                                        )
                                        .foregroundColor(.white)
                                        .onChange(of: confirmPassword) {
                                            if confirmPasswordError != nil { confirmPasswordError = nil }
                                        }
                                    } else {
                                        SecureField("", text: $confirmPassword, prompt: Text("Re-enter your password")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(.gray)
                                        )
                                        .foregroundColor(.white)
                                        .onChange(of: confirmPassword) {
                                            if confirmPasswordError != nil { confirmPasswordError = nil }
                                        }
                                    }
                                    
                                    Button(action: {
                                        isConfirmPasswordVisible.toggle()
                                    }) {
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
                        
                        // 3. Terms & Conditions Checkbox
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 8) {
                                Button(action: {
                                    withAnimation(.easeIn(duration: 0.1)) {
                                        isAccepted.toggle()
                                        FilesUserDefaultsHelper.setTermsStatus(isAccepted)
                                        if termsError != nil { termsError = nil }
                                    }
                                }) {
                                    Image(systemName: isAccepted ? "checkmark.square.fill" : "square")
                                        .font(.system(size: 16))
                                        .foregroundColor(isAccepted ? Color("secondary") : (termsError != nil ? .red : .white))
                                }
                                .buttonStyle(PlainButtonStyle())
                                
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
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            
                            if let termsError = termsError {
                                Text(termsError)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.red)
                                    .padding(.leading, 24)
                                    .transition(.opacity.combined(with: .move(edge: .top)))
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 4)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 16)
                }
                .scrollDismissesKeyboard(.interactively)
                
                Spacer(minLength: 10)
                
                // 4. Bottom Action Buttons (Sticky 16pt above Home Bar)
                VStack(spacing: 12) {
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
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            hideKeyboard()
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
                Task {
                    do {
                        try await registerUser()
                    } catch let error as AuthError {
                        emailError = error.errorDescription
                    } catch {
                        emailError = "Failed to save account. Please try again."
                    }
                }
            }
        }
    }
    
    private func registerUser() async throws -> String {
        let context = viewContext
        let userService = UserService(context: context)
        
        do {
            let userId = try await userService.registerUser(fullName: fullName, email: email, password: password)
            // Update status login global
            isUserLoggedIn = true
            currentUserId = userId
            // Redirect ke halaman awal (bypass auth)
            activePage = nil
            return userId
        } catch let error as AuthError {
            emailError = error.errorDescription
            return ""
        } catch {
            emailError = "Failed to save account. Please try again."
            return ""
        }
    }
    

    

}

#Preview {
    NavigationStack {
        SignUpPage(activePage: .constant(.signUp))
    }
}
