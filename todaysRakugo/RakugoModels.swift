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
    let characterLayers: [CharacterLayer]
    let japaneseDialogue: String
    let englishSubtitle: String
    let narrationAudio: String?
    let ambientEffect: AmbientEffect
}

enum SceneBackgroundKey: String, Codable {
    case yoseInterior
    case sobaStand
    case moonlitEdoStreet
    case narrowAlley
    case quietRoom
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
