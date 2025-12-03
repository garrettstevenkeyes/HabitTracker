//
//  HobbyView.swift
//  HabitTracker
//
//  Created by Garrett Keyes on 12/2/25.
//

import SwiftUI

struct HobbyView: View {
    let hobby: Hobby
    var onUpdate: (_ id: String, _ newDescription: String) -> Void = { _, _ in }

    @State private var editableDescription: String = ""

    var body: some View {
        ZStack {
            // Background matching ContentView
            ZStack {
                AngularGradient(
                    gradient: Gradient(colors: [
                        .blue, .indigo, .purple, .pink, .red,
                        .orange, .yellow, .green, .teal, .blue
                    ]),
                    center: .center
                )
                .opacity(0.55)

                RadialGradient(
                    gradient: Gradient(colors: [
                        .black.opacity(0.2), .clear, .white.opacity(0.08)
                    ]),
                    center: .center,
                    startRadius: 20,
                    endRadius: 600
                )
                .blendMode(.screen)
            }
            .ignoresSafeArea()

            // Foreground card with editable description
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(hobby.name)
                        .font(.title2.bold())
                        .foregroundStyle(.white)

                    TextEditor(text: $editableDescription)
                        .scrollContentBackground(.hidden)
                        .foregroundStyle(.white)
                        .padding(8)
                        .frame(minHeight: 150)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.black.opacity(0.25))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.white.opacity(0.06), lineWidth: 1)
                                )
                        )
                }
                .padding()
            }
        }
        .navigationTitle(hobby.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    onUpdate(hobby.id, editableDescription)
                }
            }
        }
        .onAppear {
            editableDescription = hobby.description
        }
    }

    init(
        hobby: Hobby,
        onUpdate: @escaping (_ id: String, _ newDescription: String) -> Void = { _, _ in }
    ) {
        self.hobby = hobby
        self.onUpdate = onUpdate
    }
}

struct HobbyHeaderView: View {
    let hobby: Hobby

    var body: some View {
        VStack(alignment: .leading) {
            Text("Mission Highlights")
                .font(.title.bold())
                .padding(.bottom, 5)
            Text(hobby.description)
        }
        .padding(.horizontal)
    }
}

#Preview {
    let hobby = Hobby(
        id: "yoga",
        name: "Yoga",
        description: "Morning stretches to make me feel good.",
        dayStreak: 2
    )

    NavigationStack {
        HobbyView(hobby: hobby)
    }
    .preferredColorScheme(.dark)
}
