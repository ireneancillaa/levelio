//
//  ContentView.swift
//  Levelio
//
//  Created by Irene Ancilla Chow on 30/05/26.
//

import SwiftUI

struct ContentView: View {
    @State private var activePage: AuthPage? = .signIn
    
    var body: some View {
        NavigationStack {
            switch activePage {
            case .signIn:
                SignInPage(activePage: $activePage)
            case .signUp:
                SignUpPage(activePage: $activePage)
            case .tnc:
                TermsAndConditionsPage(activePage: $activePage, isAccepted: .constant(false))
            default:
                SignInPage(activePage: $activePage)
            }
        }
    }
}
