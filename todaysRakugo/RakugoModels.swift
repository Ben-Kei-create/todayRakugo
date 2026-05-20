//
//  RakugoModels.swift
//  todaysRakugo
//
//  Created by Codex on 2026/05/18.
//

import Foundation

struct RakugoStory: Codable, Equatable, Identifiable {
    let id: String
    let titleJapanese: String
    let titleEnglish: String
    let category: RakugoCategory
    let featuredLabel: String
    let summary: String
    let scenes: [RakugoScene]
}

enum RakugoCategory: String, Codable, CaseIterable, Identifiable {
    case humanDrama
    case comedy
    case ghostStories
    case longStories

    var id: String { rawValue }

    var japaneseTitle: String {
        switch self {
        case .humanDrama:
            "人情噺"
        case .comedy:
            "滑稽噺"
        case .ghostStories:
            "怪談噺"
        case .longStories:
            "長編噺"
        }
    }

    var englishTitle: String {
        switch self {
        case .humanDrama:
            "Human drama"
        case .comedy:
            "Comedy"
        case .ghostStories:
            "Ghost stories"
        case .longStories:
            "Long stories"
        }
    }

    var symbolName: String {
        switch self {
        case .humanDrama:
            "fan"
        case .comedy:
            "sparkles"
        case .ghostStories:
            "moon.stars"
        case .longStories:
            "leaf"
        }
    }
}

struct RakugoScene: Codable, Equatable, Identifiable {
    let id: String
    let backgroundKey: SceneBackgroundKey
    let backgroundAssetName: String?
    let characterLayers: [CharacterLayer]
    let decorativeLayer: SceneDecorativeLayer?
    let japaneseDialogue: String
    let englishSubtitle: String
    let narrationAvailable: Bool
    let narrationAudio: String?
    let ambientEffect: AmbientEffect
    let composition: SceneComposition
    let transitionType: SceneTransitionType

    private enum CodingKeys: String, CodingKey {
        case id
        case backgroundKey
        case backgroundAssetName
        case characterLayers
        case decorativeLayer
        case japaneseDialogue
        case englishSubtitle
        case narrationAvailable
        case narrationAudio
        case ambientEffect
        case composition
        case transitionType
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        backgroundKey = try container.decode(SceneBackgroundKey.self, forKey: .backgroundKey)
        backgroundAssetName = try container.decodeIfPresent(String.self, forKey: .backgroundAssetName)
        characterLayers = try container.decodeIfPresent([CharacterLayer].self, forKey: .characterLayers) ?? []
        decorativeLayer = try container.decodeIfPresent(SceneDecorativeLayer.self, forKey: .decorativeLayer)
        japaneseDialogue = try container.decode(String.self, forKey: .japaneseDialogue)
        englishSubtitle = try container.decode(String.self, forKey: .englishSubtitle)
        narrationAudio = try container.decodeIfPresent(String.self, forKey: .narrationAudio)
        narrationAvailable = try container.decodeIfPresent(Bool.self, forKey: .narrationAvailable) ?? (narrationAudio != nil)
        ambientEffect = try container.decodeIfPresent(AmbientEffect.self, forKey: .ambientEffect) ?? .paper
        composition = try container.decodeIfPresent(SceneComposition.self, forKey: .composition) ?? .balanced
        transitionType = try container.decodeIfPresent(SceneTransitionType.self, forKey: .transitionType) ?? .crossDissolve
    }
}

enum SceneBackgroundKey: String, Codable {
    case yoseInterior
    case sobaStand
    case sobaCounter
    case moonlitEdoStreet
    case emptyEdoStreet
    case narrowAlley
    case quietRoom
}

enum SceneDecorativeLayer: String, Codable {
    case lanternGlow
    case moonAndStars
    case steam
    case paperDust
}

struct CharacterLayer: Codable, Equatable, Identifiable {
    let id: String
    let characterKey: String
    let expressionKey: String
    let placement: CharacterPlacement
}

enum CharacterPlacement: String, Codable {
    case left
    case center
    case right
}

enum AmbientEffect: String, Codable {
    case lantern
    case moon
    case paper
}

enum SceneComposition: String, Codable {
    case balanced
    case wide
    case close
    case tabletop
    case quietPause
}

enum SceneTransitionType: String, Codable {
    case fade
    case crossDissolve
    case quietHold
    case comedicBeat
    case endingHold
}

enum AppTab: String, CaseIterable, Identifiable {
    case home
    case search
    case library
    case settings

    var id: String { rawValue }

    var title: String {
        switch self {
        case .home:
            "ホーム"
        case .search:
            "さがす"
        case .library:
            "ライブラリ"
        case .settings:
            "設定"
        }
    }

    var englishTitle: String {
        switch self {
        case .home:
            "Home"
        case .search:
            "Search"
        case .library:
            "Library"
        case .settings:
            "Settings"
        }
    }

    var symbolName: String {
        switch self {
        case .home:
            "house.fill"
        case .search:
            "magnifyingglass"
        case .library:
            "books.vertical"
        case .settings:
            "gearshape"
        }
    }
}
