//
//  RakugoDesignSystem.swift
//  todaysRakugo
//
//  Created by Codex on 2026/05/18.
//

import SwiftUI

extension Color {
    static let washiIvory = Color(red: 246.0 / 255.0, green: 241.0 / 255.0, blue: 231.0 / 255.0)
    static let warmPaper = Color(red: 250.0 / 255.0, green: 246.0 / 255.0, blue: 237.0 / 255.0)
    static let sumiBlack = Color(red: 42.0 / 255.0, green: 33.0 / 255.0, blue: 27.0 / 255.0)
    static let rakugoVermilion = Color(red: 182.0 / 255.0, green: 73.0 / 255.0, blue: 45.0 / 255.0)
    static let lanternOrange = Color(red: 216.0 / 255.0, green: 122.0 / 255.0, blue: 44.0 / 255.0)
    static let mossGreen = Color(red: 77.0 / 255.0, green: 90.0 / 255.0, blue: 69.0 / 255.0)
    static let oldWood = Color(red: 92.0 / 255.0, green: 66.0 / 255.0, blue: 49.0 / 255.0)
    static let paleInk = Color(red: 154.0 / 255.0, green: 135.0 / 255.0, blue: 112.0 / 255.0)
}

extension Font {
    static func rakugoTitle(_ size: CGFloat) -> Font {
        .custom("HiraMinProN-W6", size: size)
    }

    static func rakugoSerif(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .serif)
    }
}

extension View {
    func paperCard(cornerRadius: CGFloat = 16, shadowOpacity: Double = 0.1) -> some View {
        clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Color.sumiBlack.opacity(0.11), lineWidth: 0.8)
            }
            .shadow(color: Color.sumiBlack.opacity(shadowOpacity), radius: 18, y: 9)
    }

    func rakugoButtonLabel() -> some View {
        font(.rakugoSerif(14, weight: .semibold))
            .foregroundStyle(Color.washiIvory)
            .tracking(0)
    }
}

struct WashiPaperBackground: View {
    @State private var isBreathing = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.warmPaper,
                    Color.washiIvory,
                    Color(red: 239.0 / 255.0, green: 232.0 / 255.0, blue: 218.0 / 255.0)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            PaperGrainLayer(strandCount: 105, maxLength: 34, baseOpacity: 0.032)
                .opacity(isBreathing ? 0.84 : 0.66)

            RadialGradient(
                colors: [Color.lanternOrange.opacity(0.11), .clear],
                center: .topTrailing,
                startRadius: 34,
                endRadius: 300
            )

            LinearGradient(
                colors: [.clear, Color.sumiBlack.opacity(0.055)],
                startPoint: .center,
                endPoint: .bottom
            )

            RadialGradient(
                colors: [.clear, Color.oldWood.opacity(0.045)],
                center: .center,
                startRadius: 160,
                endRadius: 520
            )
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeInOut(duration: 9).repeatForever(autoreverses: true)) {
                isBreathing = true
            }
        }
    }
}

struct PaperGrainLayer: View {
    var strandCount = 120
    var maxLength: CGFloat = 42
    var baseOpacity = 0.055

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                ForEach(0..<strandCount, id: \.self) { index in
                    Capsule()
                        .fill(index.isMultiple(of: 4) ? Color.white.opacity(0.22) : Color.sumiBlack.opacity(baseOpacity))
                        .frame(width: grainWidth(index), height: grainHeight(index))
                        .rotationEffect(.degrees(Double((index * 23) % 170)))
                        .position(
                            x: normalized(index * 37, in: proxy.size.width),
                            y: normalized(index * 61, in: proxy.size.height)
                        )
                }
            }
        }
        .allowsHitTesting(false)
    }

    private func grainWidth(_ index: Int) -> CGFloat {
        CGFloat(5 + (index * 11) % Int(maxLength))
    }

    private func grainHeight(_ index: Int) -> CGFloat {
        CGFloat(0.45 + Double((index * 7) % 3) * 0.22)
    }

    private func normalized(_ seed: Int, in length: CGFloat) -> CGFloat {
        length * CGFloat(seed % 100) / 100.0
    }
}

struct LanternView: View {
    var size: CGFloat = 64
    var showsCord = true

    @State private var isGlowing = false

    var body: some View {
        VStack(spacing: 0) {
            if showsCord {
                Rectangle()
                    .fill(Color.sumiBlack.opacity(0.45))
                    .frame(width: 1, height: size * 0.42)
            }

            ZStack {
                Circle()
                    .fill(Color.lanternOrange.opacity(isGlowing ? 0.2 : 0.12))
                    .frame(width: size * 2.05, height: size * 2.05)
                    .blur(radius: size * 0.25)

                RoundedRectangle(cornerRadius: size * 0.34, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.rakugoVermilion.opacity(0.78),
                                Color.lanternOrange.opacity(0.88),
                                Color.rakugoVermilion.opacity(0.74)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: size * 0.78, height: size)
                    .overlay {
                        VStack(spacing: size * 0.16) {
                            ForEach(0..<4, id: \.self) { _ in
                                Capsule()
                                    .fill(Color.sumiBlack.opacity(0.14))
                                    .frame(height: 1)
                            }
                        }
                        .padding(.horizontal, size * 0.1)
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: size * 0.34, style: .continuous)
                            .stroke(Color.sumiBlack.opacity(0.24), lineWidth: 1)
                    }

                VStack {
                    Rectangle()
                        .fill(Color.sumiBlack.opacity(0.38))
                        .frame(width: size * 0.48, height: 3)
                    Spacer()
                    Rectangle()
                        .fill(Color.sumiBlack.opacity(0.38))
                        .frame(width: size * 0.38, height: 3)
                }
                .frame(width: size * 0.78, height: size + 6)
            }
            .frame(width: size * 1.3, height: size * 1.16)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 3.6).repeatForever(autoreverses: true)) {
                isGlowing = true
            }
        }
    }
}

struct VerticalText: View {
    let text: String
    var font: Font = .rakugoTitle(42)
    var color: Color = Color.sumiBlack
    var spacing: CGFloat = 2

    var body: some View {
        VStack(spacing: spacing) {
            ForEach(Array(text.map(String.init).enumerated()), id: \.offset) { _, character in
                Text(character)
                    .font(font)
                    .foregroundStyle(color)
                    .tracking(0)
            }
        }
        .fixedSize()
    }
}

struct PageDots: View {
    var count: Int
    var activeIndex: Int

    var body: some View {
        HStack(spacing: 7) {
            ForEach(0..<count, id: \.self) { index in
                Circle()
                    .fill(index == activeIndex ? Color.rakugoVermilion : Color.sumiBlack.opacity(0.22))
                    .frame(width: index == activeIndex ? 6 : 5, height: index == activeIndex ? 6 : 5)
            }
        }
        .accessibilityLabel("Page \(activeIndex + 1) of \(count)")
    }
}

struct RakugoIconButton: View {
    let symbolName: String
    var accessibilityLabel: String
    var isSelected = false
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: symbolName)
                .font(.system(size: 19, weight: .regular))
                .foregroundStyle(isSelected ? Color.rakugoVermilion : Color.sumiBlack)
                .frame(width: 42, height: 42)
                .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(accessibilityLabel)
    }
}

struct RakugoSectionHeader: View {
    let title: String
    var trailing: String?

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(.rakugoSerif(15, weight: .semibold))
                .foregroundStyle(Color.sumiBlack)

            Spacer()

            if let trailing {
                Text(trailing)
                    .font(.rakugoSerif(10, weight: .semibold))
                    .foregroundStyle(Color.oldWood.opacity(0.74))
            }
        }
    }
}

struct StoryIllustrationPlaceholder: View {
    let backgroundKey: SceneBackgroundKey
    var backgroundAssetName: String?
    var characterLayers: [CharacterLayer] = []
    var decorativeLayer: SceneDecorativeLayer?
    var mood: AmbientEffect = .paper
    var composition: SceneComposition = .balanced
    var cornerRadius: CGFloat = 18

    @State private var atmospherePhase = false

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                if let backgroundAssetName {
                    Image(backgroundAssetName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .clipped()
                } else {
                    backgroundBase(for: backgroundKey)
                }

                paperScratches

                if backgroundAssetName == nil {
                    switch backgroundKey {
                    case .yoseInterior:
                        yoseInterior(in: proxy.size)
                    case .sobaStand:
                        sobaStand(in: proxy.size)
                    case .sobaCounter:
                        sobaCounter(in: proxy.size)
                    case .moonlitEdoStreet:
                        moonlitStreet(in: proxy.size)
                    case .emptyEdoStreet:
                        emptyEdoStreet(in: proxy.size)
                    case .narrowAlley:
                        narrowAlley(in: proxy.size)
                    case .quietRoom:
                        quietRoom(in: proxy.size)
                    }
                }

                ForEach(characterLayers) { layer in
                    CharacterPlaceholder(layer: layer)
                        .frame(
                            width: proxy.size.width * characterWidth,
                            height: proxy.size.height * characterHeight
                        )
                        .position(characterPosition(layer.placement, in: proxy.size, composition: composition))
                        .opacity(composition == .wide ? 0.78 : 0.88)
                        .transition(.opacity)
                }

                decorativeOverlay(decorativeLayer, in: proxy.size, phase: atmospherePhase)
                    .accessibilityHidden(true)

                if mood == .lantern {
                    RadialGradient(
                        colors: [Color.lanternOrange.opacity(atmospherePhase ? 0.29 : 0.22), .clear],
                        center: .topLeading,
                        startRadius: 24,
                        endRadius: proxy.size.width * 0.65
                    )
                } else if mood == .moon {
                    RadialGradient(
                        colors: [.white.opacity(atmospherePhase ? 0.2 : 0.15), .clear],
                        center: .topTrailing,
                        startRadius: 18,
                        endRadius: proxy.size.width * 0.55
                    )
                }

                LinearGradient(
                    colors: [
                        Color.sumiBlack.opacity(composition.vignetteOpacity),
                        .clear,
                        Color.sumiBlack.opacity(composition.vignetteOpacity * 0.5)
                    ],
                    startPoint: .bottom,
                    endPoint: .top
                )

                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Color.washiIvory.opacity(0.22), lineWidth: 1)
                    .padding(1.5)
            }
        }
        .background(Color.washiIvory)
        .paperCard(cornerRadius: cornerRadius, shadowOpacity: 0.12)
        .onAppear {
            withAnimation(.easeInOut(duration: 6.8).repeatForever(autoreverses: true)) {
                atmospherePhase = true
            }
        }
    }

    private var paperScratches: some View {
        ZStack {
            ForEach(0..<26, id: \.self) { index in
                Capsule()
                    .fill(index.isMultiple(of: 4) ? Color.washiIvory.opacity(0.12) : Color.sumiBlack.opacity(0.04))
                    .frame(width: CGFloat(10 + (index * 17) % 58), height: 0.7)
                    .rotationEffect(.degrees(Double((index * 31) % 150) - 75))
                    .offset(x: CGFloat((index * 41) % 220) - 110, y: CGFloat((index * 53) % 260) - 130)
            }
        }
        .allowsHitTesting(false)
    }

    private func backgroundBase(for key: SceneBackgroundKey) -> some View {
        let colors: [Color]

        switch key {
        case .moonlitEdoStreet:
            colors = [Color.mossGreen.opacity(0.62), Color.sumiBlack.opacity(0.84)]
        case .emptyEdoStreet:
            colors = [Color.washiIvory.opacity(0.4), Color.mossGreen.opacity(0.54), Color.sumiBlack.opacity(0.82)]
        case .sobaStand:
            colors = [Color.oldWood.opacity(0.68), Color.washiIvory.opacity(0.7)]
        case .sobaCounter:
            colors = [Color.oldWood.opacity(0.62), Color.washiIvory.opacity(0.78)]
        case .narrowAlley:
            colors = [Color.mossGreen.opacity(0.52), Color.oldWood.opacity(0.58)]
        case .quietRoom:
            colors = [Color.washiIvory.opacity(0.88), Color.oldWood.opacity(0.32)]
        case .yoseInterior:
            colors = [Color.oldWood.opacity(0.5), Color.washiIvory.opacity(0.76)]
        }

        return LinearGradient(colors: colors, startPoint: .top, endPoint: .bottom)
    }

    private var characterWidth: CGFloat {
        switch composition {
        case .wide, .quietPause:
            0.22
        case .close:
            0.36
        case .tabletop:
            0.26
        case .balanced:
            0.29
        }
    }

    private var characterHeight: CGFloat {
        switch composition {
        case .wide, .quietPause:
            0.39
        case .close:
            0.58
        case .tabletop:
            0.44
        case .balanced:
            0.48
        }
    }

    private func characterPosition(_ placement: CharacterPlacement, in size: CGSize, composition: SceneComposition) -> CGPoint {
        let verticalAnchor: CGFloat

        switch composition {
        case .wide:
            verticalAnchor = size.height * 0.71
        case .close:
            verticalAnchor = size.height * 0.7
        case .tabletop:
            verticalAnchor = size.height * 0.72
        case .quietPause:
            verticalAnchor = size.height * 0.76
        case .balanced:
            verticalAnchor = size.height * 0.67
        }

        switch placement {
        case .left:
            return CGPoint(x: size.width * composition.leftPlacementX, y: verticalAnchor)
        case .center:
            return CGPoint(x: size.width * composition.centerPlacementX, y: verticalAnchor)
        case .right:
            return CGPoint(x: size.width * composition.rightPlacementX, y: verticalAnchor)
        }
    }

    @ViewBuilder
    private func decorativeOverlay(_ layer: SceneDecorativeLayer?, in size: CGSize, phase: Bool) -> some View {
        switch layer {
        case .lanternGlow:
            RadialGradient(
                colors: [Color.lanternOrange.opacity(phase ? 0.28 : 0.19), .clear],
                center: .bottomTrailing,
                startRadius: 18,
                endRadius: size.width * 0.5
            )
        case .moonAndStars:
            ZStack {
                Circle()
                    .fill(Color.washiIvory.opacity(phase ? 0.38 : 0.3))
                    .frame(width: size.width * 0.13, height: size.width * 0.13)
                    .position(x: size.width * 0.18, y: size.height * 0.17)

                ForEach(0..<7, id: \.self) { index in
                    Image(systemName: "sparkle")
                        .font(.system(size: 5 + CGFloat(index % 3) * 2, weight: .light))
                        .foregroundStyle(Color.washiIvory.opacity(phase ? 0.26 : 0.18))
                        .position(
                            x: size.width * CGFloat(0.18 + Double((index * 13) % 68) / 100.0),
                            y: size.height * CGFloat(0.14 + Double((index * 19) % 34) / 100.0) + (phase ? -2 : 2)
                        )
                }
            }
        case .steam:
            ZStack {
                ForEach(0..<5, id: \.self) { index in
                    Capsule()
                        .stroke(Color.washiIvory.opacity(phase ? 0.23 : 0.13), lineWidth: 1.1)
                        .frame(width: size.width * 0.08, height: size.height * (phase ? 0.21 : 0.17))
                        .rotationEffect(.degrees(Double(index * 7) - 12 + (phase ? 2 : -1)))
                        .position(
                            x: size.width * CGFloat(0.38 + Double(index) * 0.055),
                            y: size.height * CGFloat(0.42 - Double(index % 2) * 0.04) + (phase ? -7 : 3)
                        )
                }
            }
        case .paperDust:
            ZStack {
                ForEach(0..<12, id: \.self) { index in
                    Circle()
                        .fill(Color.washiIvory.opacity(index.isMultiple(of: 3) ? 0.18 : 0.1))
                        .frame(width: CGFloat(2 + index % 4), height: CGFloat(2 + index % 4))
                        .position(
                            x: size.width * CGFloat(Double((index * 17) % 86) / 100.0 + 0.07),
                            y: size.height * CGFloat(Double((index * 29) % 70) / 100.0 + 0.12) + (phase ? -5 : 2)
                        )
                        .opacity(phase ? 0.9 : 0.58)
                }
            }
        case nil:
            EmptyView()
        }
    }

    @ViewBuilder
    private func yoseInterior(in size: CGSize) -> some View {
        Path { path in
            path.move(to: CGPoint(x: size.width * 0.12, y: size.height * 0.72))
            path.addLine(to: CGPoint(x: size.width * 0.88, y: size.height * 0.72))
            path.addLine(to: CGPoint(x: size.width * 0.8, y: size.height * 0.9))
            path.addLine(to: CGPoint(x: size.width * 0.2, y: size.height * 0.9))
            path.closeSubpath()
        }
        .fill(Color.oldWood.opacity(0.56))

        Path { path in
            path.move(to: CGPoint(x: size.width * 0.18, y: size.height * 0.2))
            path.addLine(to: CGPoint(x: size.width * 0.82, y: size.height * 0.2))
            path.addLine(to: CGPoint(x: size.width * 0.76, y: size.height * 0.72))
            path.addLine(to: CGPoint(x: size.width * 0.24, y: size.height * 0.72))
            path.closeSubpath()
        }
        .stroke(Color.sumiBlack.opacity(0.2), lineWidth: 2)

        LanternView(size: size.width * 0.15, showsCord: false)
            .position(x: size.width * 0.18, y: size.height * 0.24)
    }

    @ViewBuilder
    private func sobaStand(in size: CGSize) -> some View {
        Rectangle()
            .fill(Color.oldWood.opacity(0.42))
            .frame(width: size.width * 0.24, height: size.height)
            .position(x: size.width * 0.86, y: size.height * 0.5)

        Path { path in
            path.move(to: CGPoint(x: size.width * 0.08, y: size.height * 0.72))
            path.addLine(to: CGPoint(x: size.width * 0.92, y: size.height * 0.72))
        }
        .stroke(Color.sumiBlack.opacity(0.25), lineWidth: 2)

        RoundedRectangle(cornerRadius: 4)
            .fill(Color.washiIvory.opacity(0.44))
            .frame(width: size.width * 0.3, height: size.height * 0.5)
            .overlay {
                VerticalText(text: "そば", font: .rakugoTitle(size.width * 0.13), color: Color.sumiBlack.opacity(0.68), spacing: -4)
            }
            .position(x: size.width * 0.76, y: size.height * 0.34)

        LanternView(size: size.width * 0.18, showsCord: true)
            .position(x: size.width * 0.19, y: size.height * 0.21)

        ForEach(0..<4, id: \.self) { index in
            RoundedRectangle(cornerRadius: 3)
                .fill(Color.sumiBlack.opacity(0.13))
                .frame(width: size.width * 0.07, height: size.height * 0.12)
                .position(x: size.width * (0.32 + CGFloat(index) * 0.08), y: size.height * 0.62)
        }
    }

    @ViewBuilder
    private func sobaCounter(in size: CGSize) -> some View {
        Rectangle()
            .fill(Color.oldWood.opacity(0.36))
            .frame(width: size.width, height: size.height * 0.36)
            .position(x: size.width * 0.5, y: size.height * 0.78)

        RoundedRectangle(cornerRadius: size.width * 0.03, style: .continuous)
            .fill(Color.washiIvory.opacity(0.58))
            .frame(width: size.width * 0.25, height: size.width * 0.18)
            .overlay {
                Circle()
                    .stroke(Color.sumiBlack.opacity(0.16), lineWidth: 1.2)
                    .padding(size.width * 0.035)
            }
            .position(x: size.width * 0.45, y: size.height * 0.56)

        ForEach(0..<6, id: \.self) { index in
            Circle()
                .fill(Color.oldWood.opacity(0.42))
                .frame(width: size.width * 0.035, height: size.width * 0.035)
                .position(
                    x: size.width * CGFloat(0.18 + Double(index) * 0.085),
                    y: size.height * 0.7
                )
        }

        Path { path in
            path.move(to: CGPoint(x: size.width * 0.12, y: size.height * 0.66))
            path.addLine(to: CGPoint(x: size.width * 0.88, y: size.height * 0.66))
        }
        .stroke(Color.sumiBlack.opacity(0.22), lineWidth: 1.4)
    }

    @ViewBuilder
    private func moonlitStreet(in size: CGSize) -> some View {
        Circle()
            .fill(Color.washiIvory.opacity(0.82))
            .frame(width: size.width * 0.17, height: size.width * 0.17)
            .position(x: size.width * 0.23, y: size.height * 0.16)

        ForEach(0..<5, id: \.self) { index in
            Path { path in
                let baseX = CGFloat(index) * size.width * 0.19
                path.move(to: CGPoint(x: baseX, y: size.height * 0.48))
                path.addLine(to: CGPoint(x: baseX + size.width * 0.13, y: size.height * 0.36))
                path.addLine(to: CGPoint(x: baseX + size.width * 0.28, y: size.height * 0.48))
                path.addLine(to: CGPoint(x: baseX + size.width * 0.25, y: size.height * 0.83))
                path.addLine(to: CGPoint(x: baseX + size.width * 0.04, y: size.height * 0.83))
                path.closeSubpath()
            }
            .fill(Color.sumiBlack.opacity(0.3))
        }

        LanternView(size: size.width * 0.13, showsCord: false)
            .position(x: size.width * 0.83, y: size.height * 0.72)
    }

    @ViewBuilder
    private func emptyEdoStreet(in size: CGSize) -> some View {
        Circle()
            .fill(Color.washiIvory.opacity(0.68))
            .frame(width: size.width * 0.15, height: size.width * 0.15)
            .position(x: size.width * 0.2, y: size.height * 0.18)

        ForEach(0..<4, id: \.self) { index in
            Path { path in
                let side = index.isMultiple(of: 2) ? -1.0 : 1.0
                let originX = side < 0 ? size.width * CGFloat(index) * 0.08 : size.width * (0.72 + CGFloat(index) * 0.045)
                path.move(to: CGPoint(x: originX, y: size.height * 0.54))
                path.addLine(to: CGPoint(x: originX + size.width * 0.14, y: size.height * 0.42))
                path.addLine(to: CGPoint(x: originX + size.width * 0.3, y: size.height * 0.54))
                path.addLine(to: CGPoint(x: originX + size.width * 0.28, y: size.height * 0.86))
                path.addLine(to: CGPoint(x: originX + size.width * 0.02, y: size.height * 0.86))
                path.closeSubpath()
            }
            .fill(Color.sumiBlack.opacity(0.26))
        }

        Path { path in
            path.move(to: CGPoint(x: size.width * 0.22, y: size.height * 0.9))
            path.addQuadCurve(
                to: CGPoint(x: size.width * 0.78, y: size.height * 0.9),
                control: CGPoint(x: size.width * 0.5, y: size.height * 0.62)
            )
        }
        .stroke(Color.washiIvory.opacity(0.16), lineWidth: 2)
    }

    @ViewBuilder
    private func narrowAlley(in size: CGSize) -> some View {
        Path { path in
            path.move(to: CGPoint(x: size.width * 0.1, y: size.height * 0.88))
            path.addLine(to: CGPoint(x: size.width * 0.45, y: size.height * 0.38))
            path.addLine(to: CGPoint(x: size.width * 0.55, y: size.height * 0.38))
            path.addLine(to: CGPoint(x: size.width * 0.9, y: size.height * 0.88))
        }
        .stroke(Color.sumiBlack.opacity(0.25), lineWidth: 2)

        ForEach(0..<4, id: \.self) { index in
            Rectangle()
                .fill(Color.oldWood.opacity(0.28))
                .frame(width: size.width * 0.2, height: size.height * 0.5)
                .rotationEffect(.degrees(index.isMultiple(of: 2) ? -4 : 4))
                .position(x: index.isMultiple(of: 2) ? size.width * 0.18 : size.width * 0.82, y: size.height * (0.5 + CGFloat(index) * 0.06))
        }

        Circle()
            .fill(Color.lanternOrange.opacity(0.34))
            .frame(width: size.width * 0.12, height: size.width * 0.12)
            .position(x: size.width * 0.52, y: size.height * 0.44)
    }

    @ViewBuilder
    private func quietRoom(in size: CGSize) -> some View {
        Rectangle()
            .fill(Color.oldWood.opacity(0.22))
            .frame(width: size.width, height: size.height * 0.24)
            .position(x: size.width * 0.5, y: size.height * 0.84)

        Rectangle()
            .fill(Color.sumiBlack.opacity(0.12))
            .frame(width: 1.3, height: size.height * 0.76)
            .position(x: size.width * 0.48, y: size.height * 0.38)

        RoundedRectangle(cornerRadius: 3)
            .fill(Color.washiIvory.opacity(0.42))
            .frame(width: size.width * 0.38, height: size.height * 0.32)
            .overlay {
                Image(systemName: "moon")
                    .font(.system(size: size.width * 0.13))
                    .foregroundStyle(Color.sumiBlack.opacity(0.22))
            }
            .position(x: size.width * 0.72, y: size.height * 0.32)
    }
}

struct CharacterPlaceholder: View {
    let layer: CharacterLayer

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size

            ZStack {
                Path { path in
                    path.move(to: CGPoint(x: size.width * 0.5, y: size.height * 0.32))
                    path.addQuadCurve(
                        to: CGPoint(x: size.width * 0.2, y: size.height * 0.96),
                        control: CGPoint(x: size.width * 0.05, y: size.height * 0.58)
                    )
                    path.addLine(to: CGPoint(x: size.width * 0.82, y: size.height * 0.96))
                    path.addQuadCurve(
                        to: CGPoint(x: size.width * 0.5, y: size.height * 0.32),
                        control: CGPoint(x: size.width * 0.94, y: size.height * 0.58)
                    )
                    path.closeSubpath()
                }
                .fill(Color.oldWood.opacity(0.52))
                .overlay {
                    Path { path in
                        path.move(to: CGPoint(x: size.width * 0.5, y: size.height * 0.32))
                        path.addQuadCurve(
                            to: CGPoint(x: size.width * 0.2, y: size.height * 0.96),
                            control: CGPoint(x: size.width * 0.05, y: size.height * 0.58)
                        )
                        path.addLine(to: CGPoint(x: size.width * 0.82, y: size.height * 0.96))
                        path.addQuadCurve(
                            to: CGPoint(x: size.width * 0.5, y: size.height * 0.32),
                            control: CGPoint(x: size.width * 0.94, y: size.height * 0.58)
                        )
                    }
                    .stroke(Color.sumiBlack.opacity(0.36), lineWidth: 1.2)
                }

                Circle()
                    .fill(Color.washiIvory.opacity(0.88))
                    .frame(width: size.width * 0.38, height: size.width * 0.38)
                    .overlay {
                        Circle()
                            .stroke(Color.sumiBlack.opacity(0.34), lineWidth: 1)
                    }
                    .position(x: size.width * 0.5, y: size.height * 0.2)

                Capsule()
                    .fill(Color.sumiBlack.opacity(0.42))
                    .frame(width: size.width * 0.32, height: size.height * 0.08)
                    .rotationEffect(.degrees(-7))
                    .position(x: size.width * 0.48, y: size.height * 0.12)

                Path { path in
                    path.move(to: CGPoint(x: size.width * 0.32, y: size.height * 0.52))
                    path.addLine(to: CGPoint(x: size.width * 0.74, y: size.height * 0.64))
                }
                .stroke(Color.sumiBlack.opacity(0.28), lineWidth: 1)
            }
        }
        .opacity(0.88)
    }
}

private extension SceneComposition {
    var vignetteOpacity: Double {
        switch self {
        case .wide, .quietPause:
            0.2
        case .close, .tabletop:
            0.32
        case .balanced:
            0.28
        }
    }

    var leftPlacementX: CGFloat {
        switch self {
        case .wide:
            0.24
        case .close:
            0.36
        case .tabletop:
            0.32
        case .quietPause:
            0.18
        case .balanced:
            0.3
        }
    }

    var centerPlacementX: CGFloat {
        switch self {
        case .wide:
            0.48
        case .close:
            0.5
        case .tabletop:
            0.54
        case .quietPause:
            0.5
        case .balanced:
            0.52
        }
    }

    var rightPlacementX: CGFloat {
        switch self {
        case .wide:
            0.76
        case .close:
            0.64
        case .tabletop:
            0.68
        case .quietPause:
            0.82
        case .balanced:
            0.72
        }
    }
}

struct EdoStreetSilhouette: View {
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size

            ZStack(alignment: .bottom) {
                Circle()
                    .fill(Color.lanternOrange.opacity(0.12))
                    .frame(width: size.width * 0.18, height: size.width * 0.18)
                    .position(x: size.width * 0.22, y: size.height * 0.24)

                ForEach(0..<7, id: \.self) { index in
                    LaunchBuilding(index: index)
                        .frame(width: size.width * 0.2, height: size.height * CGFloat(0.42 + Double(index % 3) * 0.08))
                        .position(
                            x: size.width * CGFloat(0.08 + Double(index) * 0.145),
                            y: size.height * CGFloat(0.74 - Double(index % 2) * 0.04)
                        )
                }

                Rectangle()
                    .fill(Color.sumiBlack.opacity(0.16))
                    .frame(height: 1)
                    .position(x: size.width * 0.5, y: size.height * 0.82)
            }
        }
    }
}

private struct LaunchBuilding: View {
    let index: Int

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size

            ZStack(alignment: .bottom) {
                Rectangle()
                    .fill(Color.oldWood.opacity(0.44))
                    .frame(width: size.width * 0.78, height: size.height * 0.62)

                Path { path in
                    path.move(to: CGPoint(x: size.width * 0.05, y: size.height * 0.36))
                    path.addLine(to: CGPoint(x: size.width * 0.5, y: size.height * 0.1))
                    path.addLine(to: CGPoint(x: size.width * 0.95, y: size.height * 0.36))
                    path.closeSubpath()
                }
                .fill(Color.sumiBlack.opacity(0.34))
                .offset(y: -size.height * 0.42)

                ForEach(0..<2, id: \.self) { windowIndex in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(windowIndex == index % 2 ? Color.lanternOrange.opacity(0.5) : Color.sumiBlack.opacity(0.18))
                        .frame(width: size.width * 0.16, height: size.height * 0.16)
                        .offset(x: CGFloat(windowIndex * 18 - 9), y: -size.height * 0.18)
                }
            }
        }
    }
}

struct PaperCurlView: View {
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Path { path in
                path.move(to: CGPoint(x: 76, y: 0))
                path.addQuadCurve(to: CGPoint(x: 0, y: 76), control: CGPoint(x: 58, y: 58))
                path.addLine(to: CGPoint(x: 76, y: 76))
                path.closeSubpath()
            }
            .fill(
                LinearGradient(
                    colors: [Color.oldWood.opacity(0.18), Color.washiIvory.opacity(0.98)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay {
                Path { path in
                    path.move(to: CGPoint(x: 72, y: 6))
                    path.addQuadCurve(to: CGPoint(x: 7, y: 72), control: CGPoint(x: 54, y: 55))
                }
                .stroke(Color.sumiBlack.opacity(0.14), lineWidth: 1)
            }
        }
        .frame(width: 76, height: 76)
        .allowsHitTesting(false)
    }
}
