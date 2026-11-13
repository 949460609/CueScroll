import Foundation
import Combine

@MainActor
final class ScriptStore: ObservableObject {
    @Published private(set) var scripts: [Script] = []

    /// Free tier keeps one script. Pro unlocks unlimited.
    static let freeScriptLimit = 1

    private let fileURL: URL
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init() {
        let folder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        fileURL = folder.appendingPathComponent("scripts.json")
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        load()
        if scripts.isEmpty {
            scripts = [Self.sampleScript]
            save()
        }
    }

    func canCreateScript(isPro: Bool) -> Bool {
        isPro || scripts.count < Self.freeScriptLimit
    }

    @discardableResult
    func add(title: String, body: String, isPro: Bool) -> Script? {
        guard canCreateScript(isPro: isPro) else { return nil }
        let script = Script(title: title, body: body)
        scripts.insert(script, at: 0)
        save()
        return script
    }

    func update(_ script: Script) {
        guard let index = scripts.firstIndex(where: { $0.id == script.id }) else { return }
        var updated = script
        updated.updatedAt = .now
        scripts[index] = updated
        save()
    }

    func delete(_ script: Script) {
        scripts.removeAll { $0.id == script.id }
        save()
    }

    func delete(at offsets: IndexSet) {
        scripts.remove(atOffsets: offsets)
        save()
    }

    private func load() {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return }
        do {
            let data = try Data(contentsOf: fileURL)
            scripts = try decoder.decode([Script].self, from: data)
                .sorted { $0.updatedAt > $1.updatedAt }
        } catch {
            scripts = []
        }
    }

    private func save() {
        do {
            let data = try encoder.encode(scripts)
            try data.write(to: fileURL, options: [.atomic])
        } catch {
            // Local-only persistence; ignore write failures silently in MVP.
        }
    }

    private static var sampleScript: Script {
        Script(
            title: "Welcome to CueScroll",
            body: """
            Look into the lens.
            Speak one clear sentence at a time.
            CueScroll keeps your lines moving so you stay natural on camera.

            Tip: start slow, then raise speed until it matches your speaking pace.
            """
        )
    }
}
