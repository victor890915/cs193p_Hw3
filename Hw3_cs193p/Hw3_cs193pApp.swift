//
//  Hw3_cs193pApp.swift
//  Hw3_cs193p
//
//  Created by 鄭勝偉 on 2023/7/25.
//

import SwiftUI

@main
struct Hw3_cs193pApp: App {
    private let game = ViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView(game: game)
        }
    }
}
