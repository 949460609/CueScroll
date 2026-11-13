import SwiftUI

struct OnboardingView: View {
    let onContinue: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.06, green: 0.07, blue: 0.09),
                    Color(red: 0.12, green: 0.08, blue: 0.05)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 28) {
                Spacer()

                Text("CueScroll")
                    .font(.system(size: 44, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(red: 0.98, green: 0.48, blue: 0.22))

                Text("Speak on camera without losing your place.")
                    .font(.system(size: 28, weight: .semibold, design: .serif))
                    .foregroundStyle(.white)
                    .fixedSize(horizontal: false, vertical: true)

                Text("A clean teleprompter for Reels, TikTok, YouTube, and client videos. Scripts stay on your device.")
                    .font(.body)
                    .foregroundStyle(.white.opacity(0.72))
                    .fixedSize(horizontal: false, vertical: true)

                VStack(alignment: .leading, spacing: 14) {
                    featureRow("doc.plaintext", "Write scripts in seconds")
                    featureRow("text.alignleft", "Smooth scroll matched to your pace")
                    featureRow("arrow.left.and.right.righttriangle.left.righttriangle.right", "Mirror mode for glass teleprompters")
                }
                .padding(.top, 8)

                Spacer()

                Button(action: onContinue) {
                    Text("Start scrolling")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(red: 0.98, green: 0.48, blue: 0.22))
                        .foregroundStyle(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
            }
            .padding(28)
        }
    }

    private func featureRow(_ icon: String, _ text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(Color(red: 0.98, green: 0.48, blue: 0.22))
                .frame(width: 24)
            Text(text)
                .foregroundStyle(.white.opacity(0.9))
        }
        .font(.subheadline)
    }
}

#Preview {
    OnboardingView(onContinue: {})
}
