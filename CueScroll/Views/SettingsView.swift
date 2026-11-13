import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var purchases: PurchaseManager
    @State private var showPaywall = false

    /// Replace with your hosted privacy policy URL before App Review.
    private let privacyPolicyURL = URL(string: "https://949460609.github.io/cuescroll-privacy/")!
    private let supportURL = URL(string: "mailto:949460609@qq.com")!

    var body: some View {
        NavigationStack {
            List {
                Section("Account") {
                    HStack {
                        Text("Plan")
                        Spacer()
                        Text(purchases.isPro ? "Pro" : "Free")
                            .foregroundStyle(.secondary)
                    }
                    if !purchases.isPro {
                        Button("Upgrade to Pro") {
                            showPaywall = true
                        }
                    }
                    Button("Restore Purchases") {
                        Task { await purchases.restore() }
                    }
                }

                Section("Legal") {
                    Link("Privacy Policy", destination: privacyPolicyURL)
                    Link("Support", destination: supportURL)
                }

                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0")
                            .foregroundStyle(.secondary)
                    }
                    Text("CueScroll keeps scripts on-device. No account. No tracking SDKs.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(PurchaseManager())
}
