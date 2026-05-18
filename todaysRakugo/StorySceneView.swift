//
//  StorySceneView.swift
//  todaysRakugo
//
//  Created by Codex on 2026/05/18.
//

import SwiftUI

struct StorySceneView: View {
    let story: RakugoStory
    let pageIndex: Int
    let isEnglishVisible: Bool
    let isBookmarked: Bool
    var onBack: () -> Void
    var onToggleLanguage: () -> Void
    var onToggleBookmark: () -> Void
    var onNext: () -> Void

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            StoryPageBackground()

            if let scene = currentScene {
                GeometryReader { proxy in
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 20) {
                            topBar
                                .padding(.top, 4)

                            StoryIllustrationPlaceholder(
                                backgroundKey: scene.backgroundKey,
                                characterLayers: scene.characterLayers,
                                mood: scene.ambientEffect,
                                cornerRadius: 16
                            )
                            .frame(height: illustrationHeight(for: proxy.size))
                            .id(scene.id)
                            .transition(.opacity)

                            DialogueBlock(scene: scene, isEnglishVisible: isEnglishVisible)
                                .id("dialogue-\(scene.id)-\(isEnglishVisible)")
                                .transition(.opacity)
                                .padding(.top, 2)

                            Spacer(minLength: 8)

                            bottomBar
                                .padding(.bottom, max(proxy.safeAreaInsets.bottom + 18, 28))
                        }
                        .padding(.horizontal, 20)
                        .frame(maxWidth: 430)
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: proxy.size.height)
                    }
                }

                PaperCurlView()
                    .padding(.trailing, 0)
                    .padding(.bottom, 0)
            }
        }
    }

    private var currentScene: RakugoScene? {
        guard story.scenes.indices.contains(pageIndex) else {
            return story.scenes.first
        }

        return story.scenes[pageIndex]
    }

    private var topBar: some View {
        ZStack {
            HStack {
                RakugoIconButton(symbolName: "chevron.left", accessibilityLabel: "Back", action: onBack)

                Spacer()

                HStack(spacing: 2) {
                    RakugoIconButton(symbolName: "character.bubble", accessibilityLabel: "Toggle translation", action: onToggleLanguage)
                    RakugoIconButton(
                        symbolName: isBookmarked ? "bookmark.fill" : "bookmark",
                        accessibilityLabel: "Bookmark",
                        isSelected: isBookmarked,
                        action: onToggleBookmark
                    )
                }
            }

            Text(story.titleJapanese)
                .font(.rakugoTitle(16.5))
                .foregroundStyle(Color.sumiBlack)
        }
        .frame(height: 46)
    }

    private var bottomBar: some View {
        ZStack {
            Text("\(pageIndex + 1) / \(story.scenes.count)")
                .font(.rakugoSerif(12, weight: .medium))
                .foregroundStyle(Color.sumiBlack.opacity(0.75))

            HStack {
                Button {} label: {
                    Image(systemName: "speaker.wave.2")
                        .font(.system(size: 15))
                        .foregroundStyle(Color.sumiBlack.opacity(0.54))
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Narration")

                Spacer()

                Button(action: onNext) {
                    Image(systemName: "arrow.right")
                        .font(.system(size: 22, weight: .light))
                        .foregroundStyle(Color.sumiBlack)
                        .frame(width: 54, height: 44)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Next page")
            }
        }
        .frame(height: 46)
    }

    private func illustrationHeight(for size: CGSize) -> CGFloat {
        min(max(size.height * 0.455, 300), 430)
    }
}

private struct StoryPageBackground: View {
    var body: some View {
        GeometryReader { proxy in
            Image("story_page_background_art")
                .resizable()
                .scaledToFill()
                .frame(width: proxy.size.width, height: proxy.size.height)
                .clipped()
        }
        .ignoresSafeArea()
        .accessibilityHidden(true)
    }
}

private struct DialogueBlock: View {
    let scene: RakugoScene
    let isEnglishVisible: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text(scene.japaneseDialogue)
                .font(.rakugoSerif(22, weight: .semibold))
                .foregroundStyle(Color.sumiBlack)
                .lineSpacing(9)
                .fixedSize(horizontal: false, vertical: true)

            Rectangle()
                .fill(Color.rakugoVermilion.opacity(0.46))
                .frame(width: 40, height: 1)

            if isEnglishVisible {
                Text(scene.englishSubtitle)
                    .font(.rakugoSerif(12.5))
                    .foregroundStyle(Color.sumiBlack.opacity(0.6))
                    .lineSpacing(5)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 8)
    }
}

#Preview {
    if let story = RakugoDataSource.loadStories().first {
        StorySceneView(
            story: story,
            pageIndex: 2,
            isEnglishVisible: true,
            isBookmarked: true,
            onBack: {},
            onToggleLanguage: {},
            onToggleBookmark: {},
            onNext: {}
        )
    }
}
