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
                Spacer()
                    .frame(height: 60)
                
                VStack(spacing: 20) {
                    Image("dino-curious")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                    
                    VStack(spacing: 5) {
                        Text("Forgot Password")
                            .font(.system(size: 32, weight: .heavy))
                            .foregroundColor(.white)
                        Text("Enter your email to receive a reset link")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.gray.opacity(0.8))
                    }
                }
                .padding(.bottom, 30)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Email").font(.system(size: 14, weight: .semibold)).foregroundColor(.white)
                    HStack(spacing: 12) {
                        Image(systemName: "envelope").foregroundColor(.gray).frame(width: 24, alignment: .center)
                        TextField("", text: $email, prompt: Text("Enter your email").font(.system(size: 14, weight: .semibold)).foregroundColor(.gray)).foregroundColor(.white).autocapitalization(.none).keyboardType(.emailAddress)
                    }
                    .padding().frame(height: 50)
                    .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.white.opacity(0.4), lineWidth: 1.5))
                }
                .padding(.horizontal, 24)
                
                Spacer()
                
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
                .padding(.bottom, 70)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    activePage = .signIn
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
            ForgotPasswordPage(activePage: .constant(.forgotPassword))
        }
}
