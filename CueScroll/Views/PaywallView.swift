import SwiftUI
import StoreKit

struct PaywallView: View {
    @EnvironmentObject private var purchases: PurchaseManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("CueScroll Pro")
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                        Text("Unlimited scripts, mirror-ready themes, and a calmer recording flow.")
                            .foregroundStyle(.secondary)
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        benefit("Unlimited scripts")
                        benefit("Pro text themes")
                        benefit("Priority updates for creators")
                        benefit("No ads. No account required.")
                    }

                    if purchases.products.isEmpty {
                        ContentUnavailableView(
                            "Products unavailable",
                            systemImage: "cart",
                            description: Text("Connect a StoreKit config in Xcode or create IAPs in App Store Connect.")
                        )
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 24)
                    } else {
                        ForEach(purchases.products, id: \.id) { product in
                            Button {
                                Task { await purchases.purchase(product) }
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(product.displayName)
                                            .font(.headline)
                                        Text(product.description)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    Text(product.displayPrice)
                                        .font(.headline)
                                }
                                .padding(16)
                                .background(Color(red: 0.12, green: 0.13, blue: 0.15))
                                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    if let error = purchases.errorMessage {
                        Text(error)
                            .font(.footnote)
                            .foregroundStyle(.red)
                    }

                    Button("Restore Purchases") {
                        Task { await purchases.restore() }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 4)

                    Text("Payment will be charged to your Apple ID. Subscriptions renew automatically unless canceled at least 24 hours before the end of the period.")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                .padding(24)
            }
            .background(Color(red: 0.05, green: 0.06, blue: 0.07))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
            .overlay {
                if purchases.isLoading {
                    ProgressView()
                        .padding(20)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .onChange(of: purchases.isPro) { _, isPro in
                if isPro { dismiss() }
            }
        }
    }

    private func benefit(_ text: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(Color(red: 0.98, green: 0.48, blue: 0.22))
            Text(text)
        }
        .font(.subheadline)
    }
}
