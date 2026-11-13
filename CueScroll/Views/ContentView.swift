import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ScriptListView()
                .tabItem {
                    Label("Scripts", systemImage: "doc.text")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
        .tint(Color(red: 0.98, green: 0.48, blue: 0.22))
    }
}

#Preview {
    ContentView()
        .environmentObject(ScriptStore())
        .environmentObject(PurchaseManager())
}
