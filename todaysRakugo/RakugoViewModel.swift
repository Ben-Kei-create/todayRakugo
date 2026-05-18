//
//  RakugoViewModel.swift
//  todaysRakugo
//
//  Created by Codex on 2026/05/18.
//

import Foundation
import Observation

@Observable
final class RakugoViewModel {
    var isShowingWelcome = true
    var selectedTab: AppTab = .home
    var openStory: RakugoStory?
    var currentPageIndex = 2
    var isEnglishVisible = true

    private(set) var stories: [RakugoStory]
    private var bookmarkedSceneIDs: Set<String> = ["toki-soba-03"]

    init(stories: [RakugoStory] = RakugoDataSource.loadStories()) {
        self.stories = stories
    }

    var featuredStory: RakugoStory? {
        stories.first
    }

    var favoriteStories: [RakugoStory] {
        Array(stories.prefix(2))
    }

    var activeSurfaceID: String {
        if isShowingWelcome {
            return "welcome"
        }

        if let openStory {
            return "story-\(openStory.id)-\(currentPageIndex)"
        }

        return "home-\(selectedTab.rawValue)"
    }

    var isCurrentSceneBookmarked: Bool {
        guard let scene = currentScene else { return false }
        return bookmarkedSceneIDs.contains(scene.id)
    }

    var currentScene: RakugoScene? {
        guard let openStory, openStory.scenes.indices.contains(currentPageIndex) else {
            return nil
        }

        return openStory.scenes[currentPageIndex]
    }

    func start() {
        isShowingWelcome = false
    }

    func open(_ story: RakugoStory, startingAt pageIndex: Int = 2) {
        openStory = story
        currentPageIndex = min(max(pageIndex, 0), max(story.scenes.count - 1, 0))
    }

    func closeStory() {
        openStory = nil
    }

    func advanceScene() {
        guard let openStory, !openStory.scenes.isEmpty else { return }
        currentPageIndex = (currentPageIndex + 1) % openStory.scenes.count
    }

    func toggleCurrentSceneBookmark() {
        guard let scene = currentScene else { return }

        if bookmarkedSceneIDs.contains(scene.id) {
            bookmarkedSceneIDs.remove(scene.id)
        } else {
            bookmarkedSceneIDs.insert(scene.id)
        }
    }
}
