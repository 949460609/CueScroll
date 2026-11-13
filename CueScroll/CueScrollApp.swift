import SwiftUI

@main
struct CueScrollApp: App {
    @StateObject private var scriptStore = ScriptStore()
    @StateObject private var purchases = PurchaseManager()
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some Scene {
        WindowGroup {
            Group {
                if hasCompletedOnboarding {
                    ContentView()
                } else {
                    OnboardingView {
                        hasCompletedOnboarding = true
                    }
                }
            }
            .environmentObject(scriptStore)
            .environmentObject(purchases)
            .preferredColorScheme(.dark)
            .task {
                await purchases.loadProducts()
                await purchases.refreshEntitlements()
            }
        }
    }
}
