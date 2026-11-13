import SwiftUI

struct ScriptListView: View {
    @EnvironmentObject private var store: ScriptStore
    @EnvironmentObject private var purchases: PurchaseManager

    @State private var showEditor = false
    @State private var editingScript: Script?
    @State private var showPaywall = false
    @State private var playScript: Script?

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.05, green: 0.06, blue: 0.07).ignoresSafeArea()

                if store.scripts.isEmpty {
                    emptyState
                } else {
                    List {
                        if !purchases.isPro {
                            freeTierBanner
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                        }

                        ForEach(store.scripts) { script in
                            ScriptRow(script: script)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    playScript = script
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        store.delete(script)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                    Button {
                                        editingScript = script
                                        showEditor = true
                                    } label: {
                                        Label("Edit", systemImage: "pencil")
                                    }
                                    .tint(.orange)
                                }
                                .listRowBackground(Color(red: 0.10, green: 0.11, blue: 0.13))
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("CueScroll")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        if store.canCreateScript(isPro: purchases.isPro) {
                            editingScript = nil
                            showEditor = true
                        } else {
                            showPaywall = true
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showEditor) {
                ScriptEditorView(script: editingScript)
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
            .fullScreenCover(item: $playScript) { script in
                TeleprompterView(script: script)
            }
        }
    }

    private var freeTierBanner: some View {
        Button {
            showPaywall = true
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Free plan: 1 script")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)
                    Text("Unlock unlimited scripts & themes with Pro")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.7))
                }
                Spacer()
                Text("Pro")
                    .font(.caption.weight(.bold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color(red: 0.98, green: 0.48, blue: 0.22))
                    .foregroundStyle(.black)
                    .clipShape(Capsule())
            }
            .padding(14)
            .background(Color(red: 0.14, green: 0.10, blue: 0.07))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "text.alignleft")
                .font(.system(size: 44))
                .foregroundStyle(Color(red: 0.98, green: 0.48, blue: 0.22))
            Text("No scripts yet")
                .font(.title3.weight(.semibold))
            Text("Create your first script and start scrolling.")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button("New Script") {
                editingScript = nil
                showEditor = true
            }
            .buttonStyle(.borderedProminent)
            .tint(Color(red: 0.98, green: 0.48, blue: 0.22))
        }
        .padding()
    }
}

private struct ScriptRow: View {
    let script: Script

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(script.title)
                .font(.headline)
                .foregroundStyle(.white)
            Text(script.preview)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.65))
                .lineLimit(2)
            HStack {
                Text("\(script.wordCount) words")
                Spacer()
                Text(script.updatedAt, style: .date)
            }
            .font(.caption)
            .foregroundStyle(.white.opacity(0.45))
        }
        .padding(.vertical, 6)
    }
}

#Preview {
    ScriptListView()
        .environmentObject(ScriptStore())
        .environmentObject(PurchaseManager())
}
