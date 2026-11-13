import SwiftUI

struct TeleprompterView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var purchases: PurchaseManager

    let script: Script

    @State private var settings = PrompterSettings()
    @State private var isPlaying = false
    @State private var offset: CGFloat = 0
    @State private var contentHeight: CGFloat = 1
    @State private var viewportHeight: CGFloat = 1
    @State private var countdown: Int? = nil
    @State private var showControls = true
    @State private var showPaywall = false
    @State private var timer = Timer.publish(every: 1.0 / 60.0, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            settings.backgroundColor.color.ignoresSafeArea()

            GeometryReader { geo in
                ScrollView(.vertical, showsIndicators: false) {
                    Text(script.body)
                        .font(.system(size: settings.fontSize, weight: .medium, design: .default))
                        .foregroundStyle(settings.textColor.color)
                        .lineSpacing(settings.lineSpacing)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 28)
                        .padding(.top, geo.size.height * 0.35)
                        .padding(.bottom, geo.size.height * 0.55)
                        .background(
                            GeometryReader { textGeo in
                                Color.clear.preference(
                                    key: ContentHeightKey.self,
                                    value: textGeo.size.height
                                )
                            }
                        )
                }
                .disabled(true)
                .offset(y: -offset)
                .scaleEffect(x: settings.isMirrored ? -1 : 1, y: 1)
                .onPreferenceChange(ContentHeightKey.self) { contentHeight = $0 }
                .onAppear { viewportHeight = geo.size.height }
                .onChange(of: geo.size.height) { _, newValue in
                    viewportHeight = newValue
                }
            }

            if let countdown {
                Text("\(countdown)")
                    .font(.system(size: 96, weight: .bold, design: .rounded))
                    .foregroundStyle(settings.textColor.color)
                    .transition(.opacity)
            }

            if showControls {
                controlsOverlay
            }
        }
        .statusBarHidden(true)
        .persistentSystemOverlays(.hidden)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                showControls.toggle()
            }
        }
        .onReceive(timer) { _ in
            tick()
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView()
        }
        .onAppear {
            startCountdown()
        }
    }

    private var controlsOverlay: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.headline)
                        .padding(12)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                }

                Spacer()

                Text(script.title)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(1)
                    .foregroundStyle(.white)

                Spacer()

                Button {
                    settings.isMirrored.toggle()
                } label: {
                    Image(systemName: settings.isMirrored ? "arrow.left.and.right.righttriangle.left.righttriangle.right.fill" : "arrow.left.and.right.righttriangle.left.righttriangle.right")
                        .font(.headline)
                        .padding(12)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)

            Spacer()

            VStack(spacing: 14) {
                HStack(spacing: 18) {
                    controlButton(isPlaying ? "pause.fill" : "play.fill") {
                        if isPlaying {
                            isPlaying = false
                        } else if countdown == nil {
                            isPlaying = true
                        }
                    }

                    controlButton("backward.fill") {
                        offset = max(0, offset - 120)
                    }

                    controlButton("goforward") {
                        offset = 0
                        startCountdown()
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    labeledSlider("Speed", value: $settings.speed, range: 8...80)
                    labeledSlider("Size", value: $settings.fontSize, range: 22...64)

                    if purchases.isPro {
                        Picker("Text", selection: $settings.textColor) {
                            ForEach([PrompterSettings.ColorOption.warmWhite, .softYellow, .mint], id: \.self) { option in
                                Text(option.label).tag(option)
                            }
                        }
                        .pickerStyle(.segmented)
                    } else {
                        Button {
                            showPaywall = true
                        } label: {
                            Text("Unlock Pro themes")
                                .font(.footnote.weight(.semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(Color(red: 0.98, green: 0.48, blue: 0.22).opacity(0.9))
                                .foregroundStyle(.black)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        }
                    }
                }
                .padding(16)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .padding(.horizontal, 16)
            }
            .padding(.bottom, 24)
        }
        .foregroundStyle(.white)
    }

    private func labeledSlider(_ title: String, value: Binding<Double>, range: ClosedRange<Double>) -> some View {
        HStack {
            Text(title)
                .font(.caption.weight(.semibold))
                .frame(width: 52, alignment: .leading)
            Slider(value: value, in: range)
                .tint(Color(red: 0.98, green: 0.48, blue: 0.22))
        }
    }

    private func controlButton(_ systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.title2.weight(.semibold))
                .frame(width: 58, height: 58)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
        }
    }

    private func startCountdown() {
        isPlaying = false
        countdown = settings.countdownSeconds
        Task {
            for value in stride(from: settings.countdownSeconds, through: 1, by: -1) {
                await MainActor.run { countdown = value }
                try? await Task.sleep(nanoseconds: 1_000_000_000)
            }
            await MainActor.run {
                countdown = nil
                isPlaying = true
                showControls = false
            }
        }
    }

    private func tick() {
        guard isPlaying, countdown == nil else { return }
        let maxOffset = max(0, contentHeight - viewportHeight)
        guard maxOffset > 0 else { return }
        offset = min(maxOffset, offset + CGFloat(settings.speed) / 60.0)
        if offset >= maxOffset {
            isPlaying = false
            showControls = true
        }
    }
}

private struct ContentHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 1
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
