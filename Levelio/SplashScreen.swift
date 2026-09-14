//
//  SplashScreen.swift
//  Levelio
//
//  Created by Irene Ancilla Chow on 20/05/26.
//

import SwiftUI

struct CarouselItem: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let subtitle: String
}

struct SplashScreen: View {
    @State private var currentPage: Int = 0
    @State private var navigateToWelcome = false
    
    // State tambahan khusus untuk mengontrol efek fade-in awal
    @State private var isViewAppeared = false
    
    let carouselItems = [
        CarouselItem(
            imageName: "dino-mountain",
            title: "Start Your Journey",
            subtitle: "Build small habits, reach big goals"
        ),
        CarouselItem(
            imageName: "dino-curious",
            title: "Stay Curious",
            subtitle: "Discover what works best for you"
        ),
        CarouselItem(
            imageName: "dino-book",
            title: "Grow Smarter",
            subtitle: "Become your best version"
        )
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background aman tanpa gangguan GeometryReader
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Spacer atas konstan untuk mengunci posisi vertikal gambar
                    Spacer()
                        .frame(height: 60)
                    
                    // TabView murni iOS
                    TabView(selection: $currentPage) {
                        ForEach(0..<carouselItems.count, id: \.self) { index in
                            let item = carouselItems[index]
                            
                            VStack(spacing: 0) {
                                // 1. Bagian Gambar: Dikunci tingginya agar tidak bergeser naik/turun
                                Image(item.imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 250)
                                
                                Spacer()
                                    .frame(height: 40) // Jarak pasti antara gambar dan teks
                                
                                // 2. Bagian Teks: Diberikan tinggi statis agar halaman 1, 2, 3 tingginya sama persis
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(item.title)
                                        .font(.system(size: 32, weight: .heavy))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Text(item.subtitle)
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.leading)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(.horizontal, 24)
                                .frame(height: 120, alignment: .top) // Mengunci tinggi area teks
                            }
                            .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    /*
                       TRICK UTAMA: Menambahkan .id(currentPage) memaksa TabView memperbarui
                       tampilannya secara instan saat tombol 'Skip' mengubah nilai state.
                    */
                    .id(currentPage)
                    
                    Spacer()
                    
                    // Indikator Halaman (Dots)
                    HStack(spacing: 8) {
                        ForEach(0..<carouselItems.count, id: \.self) { index in
                            Capsule()
                                .fill(currentPage == index ? Color.white : Color.gray.opacity(0.5))
                                .frame(width: currentPage == index ? 24 : 12, height: 4)
                        }
                    }
                    .animation(.easeInOut, value: currentPage)
                    .padding(.bottom, 40)
                    
                    // Bagian Tombol Aksi
                    VStack(spacing: 16) {
                        let isLastPage = currentPage == carouselItems.count - 1
                        
                        Button(action: {
                            if isLastPage {
                                navigateToWelcome = true
                            }
                        }) {
                            Text("Get Started")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(isLastPage ? .black : .gray)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(isLastPage ? Color.white : Color.white.opacity(0.3))
                                .cornerRadius(25)
                                .padding(.horizontal, 24)
                        }
                        .disabled(!isLastPage)
                        
                        Button(action: {
                            // Memicu perpindahan halaman ke index terakhir dengan animasi bawaan iOS
                            withAnimation(.easeInOut(duration: 0.4)) {
                                currentPage = carouselItems.count - 1
                            }
                        }) {
                            Text("Skip")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .opacity(isLastPage ? 0 : 1)
                        }
                        .disabled(isLastPage)
                    }
                    .padding(.bottom, 50)
                }
            }
            // Mengatur transparansi seluruh hierarki ZStack berdasarkan state animasi
            .opacity(isViewAppeared ? 1.0 : 0.0)
            // Memicu perubahan state transisi menjadi tampak (fade-in) saat layar dimuat
            .onAppear {
                withAnimation(.easeIn(duration: 0.6)) {
                    isViewAppeared = true
                }
            }
            .navigationDestination(isPresented: $navigateToWelcome) {
                WelcomeScreen()
            }
        }
    }
}

#Preview {
    SplashScreen()
}
