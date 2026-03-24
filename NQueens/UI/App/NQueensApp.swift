//
//  NQueensApp.swift
//  NQueens
//
//  Created by Romuald Szauer on 18/3/26.
//

import SwiftUI

@main
struct NQueensApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ConfigurationView(viewModel: .init())
            }
        }
    }
}
