//
//  WelcomeView.swift
//  todaysRakugo
//
//  Created by Codex on 2026/05/18.
//

import SwiftUI

struct WelcomeView: View {
    var onStart: () -> Void

    @State private var hasAppeared = false

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Image("welcome_top_art")
                    .resizable()
                    .scaledToFill()
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .clipped()
                    .ignoresSafeArea()
                    .accessibilityHidden(true)

                VStack(spacing: 0) {
                    Spacer()

                    PageDots(count: 3, activeIndex: 0)
                        .padding(.bottom, 22)
                        .opacity(hasAppeared ? 1 : 0)

                    Button(action: onStart) {
                        HStack(spacing: 16) {
                            Image(systemName: "arrow.right")
                                .font(.system(size: 17, weight: .light))

                            VStack(spacing: 2) {
                                Text("はじめる")
                                    .rakugoButtonLabel()
                                Text("Start")
                                    .font(.rakugoSerif(10))
                                    .foregroundStyle(Color.washiIvory.opacity(0.78))
                            }
                            .frame(maxWidth: .infinity)

                            Image(systemName: "chevron.right")
                                .font(.system(size: 17, weight: .light))
                        }
                        .foregroundStyle(Color.washiIvory)
                        .padding(.horizontal, 28)
                        .frame(height: 56)
                        .background(Color.rakugoVermilion, in: Capsule())
                        .overlay {
                            Capsule()
                                .stroke(Color.washiIvory.opacity(0.16), lineWidth: 0.8)
                        }
                        .shadow(color: Color.sumiBlack.opacity(0.14), radius: 18, y: 10)
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 48)
                    .padding(.bottom, max(proxy.safeAreaInsets.bottom + 12, 26))
                    .opacity(hasAppeared ? 1 : 0)
                    .offset(y: hasAppeared ? 0 : 8)
                    .accessibilityLabel("Start")
                }
                .frame(maxWidth: min(proxy.size.width, 430))
                .frame(maxWidth: .infinity)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                hasAppeared = true
            }
        }
    }
}

#Preview {
    WelcomeView {}
}
