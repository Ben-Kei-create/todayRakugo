//
//  HomeShellView.swift
//  todaysRakugo
//
//  Created by Codex on 2026/05/18.
//

import SwiftUI

struct HomeShellView: View {
    let viewModel: RakugoViewModel

    @State private var narrationEnabled = true
    @State private var nightReading = true

    var body: some View {
        ZStack {
            HomeParchmentBackground()

            VStack(spacing: 0) {
                topBar
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 12)
                    .frame(maxWidth: 430)

                ScrollView(showsIndicators: false) {
                    Group {
                        switch viewModel.selectedTab {
                        case .home:
                            HomeTabContent(viewModel: viewModel)
                        case .search:
                            SearchTabContent(viewModel: viewModel)
                        case .library:
                            LibraryTabContent(viewModel: viewModel)
                        case .settings:
                            SettingsTabContent(narrationEnabled: $narrationEnabled, nightReading: $nightReading)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 14)
                    .padding(.bottom, 112)
                    .frame(maxWidth: 430)
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            bottomNavigation
        }
    }

    private var topBar: some View {
        ZStack {
            HStack {
                RakugoIconButton(symbolName: "line.3.horizontal", accessibilityLabel: "Menu") {}
                    .opacity(0.66)

                Spacer()

                LanternView(size: 22, showsCord: false)
                    .frame(width: 38, height: 38)
                    .opacity(0.72)
                    .accessibilityHidden(true)
            }

            Text("きょう寄席")
                .font(.rakugoTitle(18))
                .foregroundStyle(Color.sumiBlack.opacity(0.86))
                .tracking(0)
        }
        .frame(height: 42)
    }

    private var bottomNavigation: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases) { tab in
                Button {
                    withAnimation(.easeInOut(duration: 0.28)) {
                        viewModel.selectedTab = tab
                    }
                } label: {
                    VStack(spacing: 3) {
                        Image(systemName: tab.symbolName)
                            .font(.system(size: 19, weight: tab == viewModel.selectedTab ? .semibold : .regular))
                        Text(tab.title)
                            .font(.rakugoSerif(9.5, weight: .semibold))
                        Text(tab.englishTitle)
                            .font(.rakugoSerif(7.5))
                            .opacity(0.66)
                    }
                    .foregroundStyle(tab == viewModel.selectedTab ? Color.rakugoVermilion.opacity(0.9) : Color.sumiBlack.opacity(0.52))
                    .frame(maxWidth: .infinity)
                    .frame(height: 62)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel(tab.englishTitle)
            }
        }
        .padding(.horizontal, 12)
        .padding(.top, 7)
        .padding(.bottom, 8)
        .background(Color.warmPaper.opacity(0.78))
        .overlay(alignment: .top) {
            Rectangle()
                .fill(Color.sumiBlack.opacity(0.07))
                .frame(height: 0.8)
        }
    }
}

private struct HomeParchmentBackground: View {
    var body: some View {
        GeometryReader { proxy in
            Image("home_background_art")
                .resizable()
                .scaledToFill()
                .frame(width: proxy.size.width, height: proxy.size.height)
                .clipped()
                .overlay {
                    LinearGradient(
                        colors: [
                            Color.warmPaper.opacity(0.10),
                            Color.washiIvory.opacity(0.02),
                            Color.washiIvory.opacity(0.12)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }
                .overlay {
                    RadialGradient(
                        colors: [Color.washiIvory.opacity(0.26), .clear],
                        center: .center,
                        startRadius: 80,
                        endRadius: 470
                    )
                }
        }
        .ignoresSafeArea()
        .accessibilityHidden(true)
    }
}

private struct HomeTabContent: View {
    let viewModel: RakugoViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            if let featuredStory = viewModel.featuredStory {
                FeaturedStoryCard(story: featuredStory) {
                    viewModel.open(featuredStory)
                }
            }

            VStack(alignment: .leading, spacing: 14) {
                RakugoSectionHeader(title: "演目をさがす", trailing: "すべて見る")

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(RakugoCategory.allCases) { category in
                        CategoryCard(category: category)
                    }
                }
            }

            VStack(alignment: .leading, spacing: 13) {
                RakugoSectionHeader(title: "お気に入り")

                VStack(spacing: 9) {
                    ForEach(viewModel.favoriteStories) { story in
                        FavoriteStoryRow(story: story) {
                            viewModel.open(story, startingAt: 0)
                        }
                    }
                }
            }
        }
    }
}

private struct FeaturedStoryCard: View {
    let story: RakugoStory
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack(alignment: .trailing) {
                StoryIllustrationPlaceholder(
                    backgroundKey: .moonlitEdoStreet,
                    characterLayers: featuredLayers,
                    mood: .lantern,
                    cornerRadius: 20
                )
                .frame(height: 338)

                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("今日の一席")
                            .font(.rakugoSerif(12, weight: .semibold))
                            .foregroundStyle(Color.washiIvory.opacity(0.92))
                        Text(story.titleEnglish)
                            .font(.rakugoSerif(11))
                            .foregroundStyle(Color.washiIvory.opacity(0.7))
                    }
                    .padding(.leading, 19)
                    .padding(.top, 22)

                    Spacer()

                    VerticalText(text: story.titleJapanese, font: .rakugoTitle(39), color: Color.washiIvory, spacing: -3)
                        .shadow(color: Color.sumiBlack.opacity(0.38), radius: 7, y: 3)
                        .padding(.trailing, 28)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(story.featuredLabel), \(story.titleEnglish)")
    }

    private var featuredLayers: [CharacterLayer] {
        story.scenes.first(where: { $0.backgroundKey == .moonlitEdoStreet })?.characterLayers ?? []
    }
}

private struct CategoryCard: View {
    let category: RakugoCategory

    var body: some View {
        VStack(spacing: 7) {
            Image(systemName: category.symbolName)
                .font(.system(size: 19, weight: .regular))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(cardTint)

            VStack(spacing: 2) {
                Text(category.japaneseTitle)
                    .font(.rakugoSerif(10.2, weight: .semibold))
                Text(category.englishTitle)
                    .font(.rakugoSerif(7.5))
                    .opacity(0.58)
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)
            }
        }
        .foregroundStyle(Color.sumiBlack.opacity(0.72))
        .frame(maxWidth: .infinity)
        .frame(height: 72)
        .background(Color.washiIvory.opacity(0.48), in: RoundedRectangle(cornerRadius: 13, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 13, style: .continuous)
                .stroke(Color.sumiBlack.opacity(0.07), lineWidth: 0.8)
        }
        .shadow(color: Color.sumiBlack.opacity(0.035), radius: 12, y: 6)
    }

    private var cardTint: Color {
        switch category {
        case .humanDrama:
            Color.mossGreen.opacity(0.82)
        case .comedy:
            Color.rakugoVermilion.opacity(0.8)
        case .ghostStories:
            Color.sumiBlack.opacity(0.68)
        case .longStories:
            Color.oldWood.opacity(0.7)
        }
    }
}

private struct FavoriteStoryRow: View {
    let story: RakugoStory
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 13) {
                MiniStoryMark(category: story.category)
                    .frame(width: 50, height: 50)

                VStack(alignment: .leading, spacing: 4) {
                    Text(story.titleJapanese)
                        .font(.rakugoSerif(14.5, weight: .semibold))
                        .foregroundStyle(Color.sumiBlack.opacity(0.86))
                    Text(story.summary)
                        .font(.rakugoSerif(9.8))
                        .foregroundStyle(Color.sumiBlack.opacity(0.52))
                        .lineLimit(2)
                }

                Spacer()

                Image(systemName: "bookmark.fill")
                    .font(.system(size: 17))
                    .foregroundStyle(Color.rakugoVermilion.opacity(0.74))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 11)
            .background(Color.washiIvory.opacity(0.54), in: RoundedRectangle(cornerRadius: 15, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .stroke(Color.sumiBlack.opacity(0.07), lineWidth: 0.8)
            }
            .shadow(color: Color.sumiBlack.opacity(0.035), radius: 10, y: 5)
        }
        .buttonStyle(.plain)
    }
}

private struct MiniStoryMark: View {
    let category: RakugoCategory

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 9, style: .continuous)
                .fill(markColor.opacity(category == .humanDrama ? 0.6 : 0.46))

            Circle()
                .fill(Color.lanternOrange.opacity(0.18))
                .frame(width: 28, height: 28)
                .offset(x: -8, y: -8)

            Image(systemName: category.symbolName)
                .font(.system(size: 18))
                .foregroundStyle(Color.washiIvory.opacity(0.82))
        }
        .overlay {
            RoundedRectangle(cornerRadius: 9, style: .continuous)
                .stroke(Color.sumiBlack.opacity(0.08), lineWidth: 0.8)
        }
    }

    private var markColor: Color {
        switch category {
        case .humanDrama:
            Color.mossGreen
        case .comedy:
            Color.rakugoVermilion
        case .ghostStories:
            Color.sumiBlack
        case .longStories:
            Color.oldWood
        }
    }
}

private struct SearchTabContent: View {
    let viewModel: RakugoViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(Color.sumiBlack.opacity(0.48))
                Text("演目をさがす")
                    .font(.rakugoSerif(15))
                    .foregroundStyle(Color.sumiBlack.opacity(0.54))
                Spacer()
            }
            .padding(.horizontal, 16)
            .frame(height: 50)
            .background(Color.washiIvory.opacity(0.74), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.sumiBlack.opacity(0.1), lineWidth: 0.8)
            }

            RakugoSectionHeader(title: "今夜のおすすめ")

            ForEach(viewModel.stories) { story in
                FavoriteStoryRow(story: story) {
                    viewModel.open(story, startingAt: 0)
                }
            }
        }
    }
}

private struct LibraryTabContent: View {
    let viewModel: RakugoViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            RakugoSectionHeader(title: "ライブラリ")

            ForEach(RakugoCategory.allCases) { category in
                HStack {
                    CategoryCard(category: category)
                        .frame(width: 92)

                    VStack(alignment: .leading, spacing: 6) {
                        Text(category.japaneseTitle)
                            .font(.rakugoSerif(16, weight: .semibold))
                            .foregroundStyle(Color.sumiBlack)
                        Text("\(viewModel.stories.filter { $0.category == category }.count) stories")
                            .font(.rakugoSerif(11))
                            .foregroundStyle(Color.sumiBlack.opacity(0.58))
                    }

                    Spacer()
                }
            }
        }
    }
}

private struct SettingsTabContent: View {
    @Binding var narrationEnabled: Bool
    @Binding var nightReading: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            RakugoSectionHeader(title: "設定")

            SettingsToggleRow(symbolName: "waveform", title: "語りの音", subtitle: "Narration", isOn: $narrationEnabled)
            SettingsToggleRow(symbolName: "moon", title: "夜の読書", subtitle: "Night reading", isOn: $nightReading)
        }
    }
}

private struct SettingsToggleRow: View {
    let symbolName: String
    let title: String
    let subtitle: String
    @Binding var isOn: Bool

    var body: some View {
        Toggle(isOn: $isOn) {
            HStack(spacing: 12) {
                Image(systemName: symbolName)
                    .font(.system(size: 18))
                    .foregroundStyle(Color.rakugoVermilion)
                    .frame(width: 28)

                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.rakugoSerif(15, weight: .semibold))
                    Text(subtitle)
                        .font(.rakugoSerif(10))
                        .opacity(0.58)
                }
            }
            .foregroundStyle(Color.sumiBlack)
        }
        .tint(Color.rakugoVermilion)
        .padding(14)
        .background(Color.washiIvory.opacity(0.72), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.sumiBlack.opacity(0.1), lineWidth: 0.8)
        }
    }
}

#Preview {
    HomeShellView(viewModel: RakugoViewModel())
}
