//
//  GithubExplorerApp.swift
//  GitHub Explorer
//
//  Created by Karnika on 30/01/26.
//

import SwiftUI
import SwiftData

@main
struct GithubExplorerApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(for: SavedRepoEntity.self)
    }
}

struct RootView: View {
    @Environment(\.modelContext) private var modelContext

    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)

        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(AppTheme.accent)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(AppTheme.accent)
        ]

        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.secondaryLabel
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.secondaryLabel
        ]

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
           TabView {

               NavigationStack {
                   SearchView()
               }
               .tabItem {
                   Label("Search", systemImage: "magnifyingglass")
               }

               NavigationStack {
                   SavedReposView(
                       vm: SavedReposViewModel(
                           store: SwiftDataSavedRepoStore(context: modelContext)
                       )
                   )
               }
               .tabItem {
                   Label("Saved", systemImage: "bookmark.fill")
               }

               NavigationStack {
                   SettingsView()
               }
               .tabItem {
                   Label("Settings", systemImage: "gearshape.fill")
               }
           }
           .tint(AppTheme.accent)
       }
}
