import SwiftUI

struct ScriptEditorView: View {
    @EnvironmentObject private var store: ScriptStore
    @EnvironmentObject private var purchases: PurchaseManager
    @Environment(\.dismiss) private var dismiss

    let script: Script?

    @State private var title: String = ""
    @State private var bodyText: String = ""
    @State private var showPaywall = false

    private var isEditing: Bool { script != nil }

    var body: some View {
        NavigationStack {
            Form {
                Section("Title") {
                    TextField("Script title", text: $title)
                }
                Section("Script") {
                    TextEditor(text: $bodyText)
                        .frame(minHeight: 260)
                }
            }
            .navigationTitle(isEditing ? "Edit Script" : "New Script")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .onAppear {
                if let script {
                    title = script.title
                    bodyText = script.body
                } else {
                    title = "Untitled"
                    bodyText = ""
                }
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
        }
    }

    private func save() {
        let cleanTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanBody = bodyText.trimmingCharacters(in: .whitespacesAndNewlines)

        if var existing = script {
            existing.title = cleanTitle
            existing.body = cleanBody
            store.update(existing)
            dismiss()
            return
        }

        if store.add(title: cleanTitle, body: cleanBody, isPro: purchases.isPro) != nil {
            dismiss()
        } else {
            showPaywall = true
        }
    }
}
