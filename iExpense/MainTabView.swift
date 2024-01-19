//
//  MainTabView.swift
//  iExpense
//
//  Created by Damien Chailloleau on 19/01/2024.
//

import SwiftData
import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .modelContainer(for: Expenses.self)
            
            StatisticsView()
                .tabItem {
                    Label("Statistics", systemImage: "chart.bar.xaxis")
                }
        }
    }
}

#Preview {
    MainTabView()
}
