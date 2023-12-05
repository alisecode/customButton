//
//  ButtonReelApp.swift
//  ButtonReel
//
//  Created by Alise Serhiienko on 04.12.2023.
//

import SwiftUI

@main
struct ButtonReelApp: App {
   
    @State private var isReset = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                Color.systemBackground
                    .ignoresSafeArea()
                ButtonView(title: "Tap Me 🔥", resetText: "Reset Me", isReset: $isReset)
                    .padding()

            }
           
        }
    }
}
