//
//  WelcomeScreen.swift
//  Levelio
//
//  Created by Irene Ancilla Chow on 20/05/26.
//

import SwiftUI
import UIKit

enum AuthPage {
    case signIn
    case signUp
    case forgotPassword
    case otp
    case tnc
}

struct WelcomeScreen: View {
    @State private var activePage: AuthPage? = nil
    
    private var isCompactScreen: Bool {
        UIScreen.isCompact
    }
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                // Hero Character & Title
                VStack(spacing: isCompactScreen ? 14 : 20) {
                    Image("dino-car")
                        .resizable()
                        .scaledToFit()
                        .frame(height: isCompactScreen ? 150 : 200)
                    
                    VStack(spacing: 8) {
                        Text("Hello Levelers!")
                            .font(.system(size: isCompactScreen ? 28 : 32, weight: .heavy))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                        
                        Text("Don't forget to keep your streak alive")
                            .font(.system(size: isCompactScreen ? 16 : 18, weight: .semibold))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.top, isCompactScreen ? 16 : 28)
                
                Spacer()
                
                // Bottom Action Buttons sticky 24pt above Home Bar
                VStack(spacing: 12) {
                    Button(action: {
                        activePage = .signIn
                    }) {
                        Text("Sign In")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.white)
                            .cornerRadius(25)
                    }
                    
                    Button(action: {
                        FilesUserDefaultsHelper.setTermsStatus(false)
                        activePage = .signUp
                    }) {
                        Text("Sign Up")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.white, lineWidth: 1.5)
                            )
                            .cornerRadius(25)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .navigationDestination(item: $activePage) { page in
            switch page {
            case .signIn:
                SignInPage(activePage: $activePage)
            case .signUp:
                SignUpPage(activePage: $activePage)
            case .forgotPassword:
                ForgotPasswordPage(activePage: $activePage)
            case .otp:
                OtpPage(activePage: $activePage)
            case .tnc:
                TermsAndConditionsPage(activePage: $activePage, isAccepted: .init(
                        get: { UserDefaults.standard.bool(forKey: "hasAcceptedTerms") },
                        set: { UserDefaults.standard.set($0, forKey: "hasAcceptedTerms") }
                    )
                )
            }
        }
    }
}

#Preview {
    WelcomeScreen()
}
