//
//  GroovyBackground.swift
//  HabitTracker
//
//  Created by Garrett Keyes on 12/2/25.
//

import SwiftUI

struct GroovyBackground: View {
    var body: some View {
        ZStack {
            AngularGradient(
                gradient: Gradient(colors: [.blue, .indigo, .purple, .pink, .red, .orange, .yellow, .green, .teal, .blue]),
                center: .center
            )
            .opacity(0.55)

            RadialGradient(
                gradient: Gradient(colors: [.black.opacity(0.2), .clear, .white.opacity(0.08)]),
                center: .center,
                startRadius: 20,
                endRadius: 600
            )
            .blendMode(.screen)
        }
        .ignoresSafeArea()
    }
}

extension View {
    func groovyBackground() -> some View {
        self.background(GroovyBackground())
    }
}
