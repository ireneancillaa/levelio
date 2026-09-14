//
//  AddPage.swift
//  Levelio
//
//  Created by Irene Ancilla Chow on 30/05/26.
//

import SwiftUI

struct AddPage: View {
    @Environment(\.dismiss) private var dismiss
    
    // --- STATE FORM DATA ---
    @State private var habitName = ""
    @State private var description = ""
    @State private var selectedColor = Color.cyan
    @State private var frequency = "Daily"
    @State private var reminderTime = "08.00am"
    
    let frequencies = ["Daily", "Weekly"]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Latar Belakang Gelap Khas Levelio
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            // --- 1. SCROLLABLE FORM CONTENT ---
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // SECTION 1: HABIT DETAIL
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Habit Detail")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                        
                        VStack(spacing: 0) {
                            HStack(spacing: 12) {
                                Image(systemName: "pencil")
                                    .foregroundColor(.white.opacity(0.6))
                                    .frame(width: 20)
                                TextField("", text: $habitName, prompt: Text("Enter habit name").foregroundColor(.gray))
                                    .foregroundColor(.white)
                            }
                            .padding(.vertical, 16)
                            
                            Divider().background(Color.white.opacity(0.15))
                            
                            HStack(alignment: .center, spacing: 12) {
                                Image(systemName: "doc.text")
                                    .foregroundColor(.white.opacity(0.6))
                                    .frame(width: 20)
                                
                                TextField("", text: $description, prompt: Text("Description").foregroundColor(.gray), axis: .vertical)
                                    .foregroundColor(.white)
                                    .lineLimit(1...5)
                            }
                            .padding(.vertical, 16)
                            
                            Divider().background(Color.white.opacity(0.15))
                            
                            HStack(spacing: 12) {
                                Image(systemName: "paintpalette")
                                    .foregroundColor(.white.opacity(0.6))
                                    .frame(width: 20)
                                Text("Color")
                                    .foregroundColor(.white)
                                Spacer()
                                Circle()
                                    .fill(selectedColor)
                                    .frame(width: 22, height: 22)
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 16)
                        }
                        .padding(.horizontal, 16)
                        .background(
                            ZStack {
                                Color.white.opacity(0.04)
                            }
                        )
                        .cornerRadius(14)
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.1), lineWidth: 1))
                    }
                    
                    // SECTION 2: SCHEDULE
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Schedule")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                        
                        VStack(spacing: 0) {
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundColor(.white.opacity(0.6))
                                    .frame(width: 20)
                                Text("Frequency")
                                    .foregroundColor(.white)
                                Spacer()
                                
                                HStack(spacing: 4) {
                                    ForEach(frequencies, id: \.self) { item in
                                        Text(item)
                                            .font(.system(size: 13, weight: .semibold))
                                            .foregroundColor(frequency == item ? .white : .gray)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 6)
                                            .background(frequency == item ? Color.white.opacity(0.2) : Color.clear)
                                            .cornerRadius(12)
                                            .onTapGesture {
                                                withAnimation(.spring(response: 0.25, dampingFraction: 0.75)) { frequency = item }
                                            }
                                    }
                                }
                                .padding(.all, 4)
                                .background(Color.black.opacity(0.3))
                                .cornerRadius(14)
                            }
                            .padding(.vertical, 12)
                            
                            Divider().background(Color.white.opacity(0.15))
                            
                            HStack(spacing: 12) {
                                Image(systemName: "clock")
                                    .foregroundColor(.white.opacity(0.6))
                                    .frame(width: 20)
                                Text("Reminder")
                                    .foregroundColor(.white)
                                Spacer()
                                Text(reminderTime)
                                    .foregroundColor(.white.opacity(0.8))
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 16)
                        }
                        .padding(.horizontal, 16)
                        .background(
                            ZStack {
                                Color.white.opacity(0.04)
                            }
                        )
                        .cornerRadius(14)
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.1), lineWidth: 1))
                    }
                    
                    // SECTION 3: UDIN'S PROGRESS
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Udin’s Progress")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                        
                        HStack(spacing: 16) {
                            Image("dino-egg-blue")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 60)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                HStack(spacing: 4) {
                                    Text("XP Gain:")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white)
                                    Text("+100")
                                        .font(.system(size: 16, weight: .heavy))
                                        .foregroundColor(.cyan)
                                }
                                
                                Text("to boost your pet’s Productivity stat")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                        .padding(.all, 16)
                        .background(
                            ZStack {
                                Color.white.opacity(0.04)
                            }
                        )
                        .cornerRadius(14)
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.1), lineWidth: 1))
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 50)
                .padding(.bottom, 160)
            }
            
            // --- 2. FIXED BOTTOM BUTTON AREA (Overlay di atas ScrollView) ---
            VStack {
                Button(action: {
                    dismiss()
                }) {
                    Text("Create Habit")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            LinearGradient(
                                colors: [Color(red: 0.35, green: 0.45, blue: 0.95), Color.cyan],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(25)
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)
                .padding(.bottom, 90)
            }
            .background(
                Color.black.opacity(0.4)
                    .blur(radius: 10)
                    .ignoresSafeArea(edges: .bottom)
            )
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        .preferredColorScheme(.dark)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.blue)
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text("New Habit")
                    .font(.system(size: 24, weight: .black))
                    .foregroundColor(.white)
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    NavigationStack {
        AddPage()
    }
}
