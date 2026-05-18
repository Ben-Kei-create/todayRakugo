//
//  ContentView.swift
//  todaysRakugo
//
//  Created by 茂木史明 on 2026/05/18.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = RakugoViewModel()

    var body: some View {
        ZStack {
            if viewModel.isShowingWelcome {
                WelcomeView {
                    withAnimation(.easeInOut(duration: 0.7)) {
                        viewModel.start()
                    }
                }
                .transition(.opacity)
            } else if let story = viewModel.openStory {
                StorySceneView(
                    story: story,
                    pageIndex: viewModel.currentPageIndex,
                    isEnglishVisible: viewModel.isEnglishVisible,
                    isBookmarked: viewModel.isCurrentSceneBookmarked,
                    onBack: {
                        withAnimation(.easeInOut(duration: 0.45)) {
                            viewModel.closeStory()
                        }
                    },
                    onToggleLanguage: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            viewModel.isEnglishVisible.toggle()
                        }
                    },
                    onToggleBookmark: {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            viewModel.toggleCurrentSceneBookmark()
                        }
                    },
                    onNext: {
                        withAnimation(.easeInOut(duration: 0.55)) {
                            viewModel.advanceScene()
                        }
                    }
                )
                .transition(.opacity)
            } else {
                HomeShellView(viewModel: viewModel)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.45), value: viewModel.activeSurfaceID)
        .tint(Color.rakugoVermilion)
        .preferredColorScheme(.light)
    }
}

#Preview {
    ContentView()
}
