//
//  AddPage.swift
//  Levelio
//
//  Created by Irene Ancilla Chow on 30/05/26.
//

import SwiftUI

struct AddPage: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var store: HabitStore
    
    struct HabitColorOption: Identifiable, Equatable {
        let id: String
        let name: String
        let color: Color
    }
    
    let colorOptions: [HabitColorOption] = [
        HabitColorOption(id: "primary", name: "Primary", color: Color("primary")),
        HabitColorOption(id: "secondary", name: "Secondary", color: Color("secondary")),
        HabitColorOption(id: "tertiary", name: "Tertiary", color: Color("tertiary"))
    ]
    
    // --- STATE FORM DATA ---
    @State private var habitName = ""
    @State private var description = ""
    @State private var selectedColorName = "primary"
    @State private var frequency = "Daily"
    @State private var reminderDate: Date = {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        components.hour = 8
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }()
    @State private var showValidationError = false
    
    private var selectedColor: Color {
        colorOptions.first(where: { $0.id == selectedColorName })?.color ?? Color("primary")
    }
    
    private var currentStage: DinoStage {
        DinoStage.stage(for: store.totalXP)
    }
    
    private var formattedReminderTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh.mma"
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: reminderDate).lowercased()
    }
    
    let frequencies = ["Daily", "Weekly"]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Latar Belakang Gelap Khas Levelio
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // --- TOP APP BAR (NO BACKGROUND COLOR) ---
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                    .buttonStyle(.glassCircle)
                    
                    Spacer()
                    
                    Text("New Habit")
                        .font(.system(size: 24, weight: .black))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Spacer penyeimbang tombol back agar teks tetap presisi di tengah
                    Color.clear
                        .frame(width: 44, height: 44)
                }
                .frame(height: 55)
                .padding(.horizontal, 24)
                .padding(.top, 12)
                .padding(.bottom, 12)
                
                // --- 1. SCROLLABLE FORM CONTENT ---
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                    
                    // SECTION 1: HABIT DETAIL
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Habit Detail")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                            
                            if showValidationError {
                                Spacer()
                                Text("Habit name is required")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.red)
                            }
                        }
                        
                        VStack(spacing: 0) {
                            HStack(spacing: 12) {
                                Image(systemName: "pencil")
                                    .foregroundColor(.white.opacity(0.6))
                                    .frame(width: 20)
                                TextField("", text: $habitName, prompt: Text("Enter habit name").foregroundColor(.gray))
                                    .foregroundColor(.white)
                                    .onChange(of: habitName) { _, _ in
                                        if showValidationError && !habitName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                            showValidationError = false
                                        }
                                    }
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
                                
                                HStack(spacing: 8) {
                                    ForEach(colorOptions) { option in
                                        Button {
                                            withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                                                selectedColorName = option.id
                                            }
                                        } label: {
                                            ZStack {
                                                Circle()
                                                    .fill(option.color)
                                                    .frame(width: 24, height: 24)
                                                
                                                if selectedColorName == option.id {
                                                    Circle()
                                                        .stroke(Color.white, lineWidth: 2)
                                                        .frame(width: 32, height: 32)
                                                    
                                                    Image(systemName: "checkmark")
                                                        .font(.system(size: 10, weight: .bold))
                                                        .foregroundColor(.white)
                                                }
                                            }
                                            .frame(width: 44, height: 44)
                                            .contentShape(Circle())
                                        }
                                        .buttonStyle(.plain)
                                        .accessibilityLabel(Text(option.name))
                                    }
                                }
                            }
                            .padding(.vertical, 8)
                        }
                        .padding(.horizontal, 16)
                        .background(
                            ZStack {
                                Color.white.opacity(0.04)
                            }
                        )
                        .cornerRadius(14)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(showValidationError ? Color.red.opacity(0.8) : Color.white.opacity(0.1), lineWidth: 1)
                        )
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
                                
                                Picker("Frequency", selection: $frequency) {
                                    ForEach(frequencies, id: \.self) { freq in
                                        Text(freq).tag(freq)
                                    }
                                }
                                .pickerStyle(.menu)
                                .tint(.cyan)
                            }
                            .padding(.vertical, 12)
                            
                            Divider().background(Color.white.opacity(0.15))
                            
                            HStack {
                                Image(systemName: "clock")
                                    .foregroundColor(.white.opacity(0.6))
                                    .frame(width: 20)
                                Text("Reminder Time")
                                    .foregroundColor(.white)
                                Spacer()
                                DatePicker(
                                    "",
                                    selection: $reminderDate,
                                    displayedComponents: .hourAndMinute
                                )
                                .labelsHidden()
                                .tint(.cyan)
                                .colorScheme(.dark)
                            }
                            .padding(.vertical, 12)
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
                    
                    // SECTION 3: YOUR PROGRESS
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Your Progress")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                        
                        HStack(spacing: 16) {
                            Image(currentStage.imageName)
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
                                
                                Text("to grow your \(currentStage.name)")
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
                .padding(.top, 10)
                .padding(.bottom, 110)
            }
            .scrollDismissesKeyboard(.interactively)
        }
            
            // --- 2. FIXED BOTTOM BUTTON AREA (Overlay di atas ScrollView) ---
            VStack {
                Button(action: {
                    let trimmed = habitName.trimmingCharacters(in: .whitespacesAndNewlines)
                    if trimmed.isEmpty {
                        showValidationError = true
                    } else {
                        store.addHabit(
                            title: trimmed,
                            description: description,
                            colorName: selectedColorName,
                            frequency: frequency,
                            time: formattedReminderTime
                        )
                        dismiss()
                    }
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
                .padding(.bottom, 24)
            }
            .background(
                Color.black.opacity(0.4)
                    .blur(radius: 10)
                    .ignoresSafeArea(edges: .bottom)
            )
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            hideKeyboard()
        }
        .preferredColorScheme(.dark)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

#Preview {
    AddPage(store: HomePage.sharedHabitStore)
}
