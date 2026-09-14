//
//  LevelioApp.swift
//  Levelio
//
//  Created by Irene Ancilla Chow on 07/04/26.
//

import SwiftUI
import SwiftData

@main
struct LevelioApp: App {
    // Pantau status login secara global di level aplikasi
    @AppStorage("isUserLoggedIn") private var isUserLoggedIn = false
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            Group {
                if isUserLoggedIn {
                    // Jika user sudah masuk sebelumnya, langsung bypass ke HomePage
                    HomePage()
                } else {
                    // Jika belum, jalankan alur Onboarding Carousel manual dari awal
                    SplashScreen()
                }
            }
            .modelContainer(sharedModelContainer)
        }
    }
}
