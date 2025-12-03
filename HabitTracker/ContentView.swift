//
//  ContentView.swift
//  HabitTracker
//
//  Created by Garrett Keyes on 12/2/25.
//

import SwiftUI

struct ContentView: View {
    @State private var hobbies: [String: Hobby] = [:]
    @State private var showingAddHobby = false
    @State private var newName: String = ""
    @State private var newDescription: String = ""
    @State private var newDayStreak: Int = 0
    
    @State private var showsGrid = true
    @State private var lastAddedHobbyID: String? = nil
    
    var body: some View {
        NavigationStack{
            GridTileView(
                hobbies: $hobbies,
                highlightedID: lastAddedHobbyID,
                onAddTapped: {
                    showingAddHobby = true
                },
                onIncrement: { id in
                    if let hobby = hobbies[id] {
                        hobbies[id] = Hobby(
                            id: hobby.id,
                            name: hobby.name,
                            description: hobby.description,
                            dayStreak: hobby.dayStreak + 1
                        )
                    }
                },
                onDecrement: { id in
                    if let hobby = hobbies[id] {
                        hobbies[id] = Hobby(
                            id: hobby.id,
                            name: hobby.name,
                            description: hobby.description,
                            dayStreak: max(0, hobby.dayStreak - 1)
                        )
                    }
                },
                onDelete: { id in
                    hobbies.removeValue(forKey: id)
                }
            )
            .sheet(isPresented: $showingAddHobby) {
                AddHobbyView(isPresented: $showingAddHobby) { id, name, description, dayStreak in
                    hobbies[id] = Hobby(
                        id: id,
                        name: name,
                        description: description,
                        dayStreak: dayStreak
                    )
                    lastAddedHobbyID = id
                }
            }
            .navigationTitle("Hobby Tracker")
            .navigationBarTitleDisplayMode(.inline)
            .background(GroovyBackground())
            .preferredColorScheme(.dark)
        }
    }
}

struct AddHobbyView: View {
    @Binding var isPresented: Bool
    var onAdd: (_ id: String, _ name: String, _ description: String, _ dayStreak: Int) -> Void

    @State private var newName: String = ""
    @State private var newDescription: String = ""
    @State private var newDayStreak: Int = 0

    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Name", text: $newName)
                    TextField("Description", text: $newDescription)
                    Stepper("Day Streak: \(newDayStreak)", value: $newDayStreak, in: 0...365)
                }
            }
            .navigationTitle("New Hobby")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                        newName = ""
                        newDescription = ""
                        newDayStreak = 0
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let id = newName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                        guard !id.isEmpty else { return }
                        onAdd(id, newName, newDescription, newDayStreak)
                        isPresented = false
                        newName = ""
                        newDescription = ""
                        newDayStreak = 0
                    }
                    .disabled(newName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

// MARK: - GridTileView

struct GridTileView: View {
    @Binding var hobbies: [String: Hobby]
    var highlightedID: String?
    var onAddTapped: () -> Void
    var onIncrement: (String) -> Void
    var onDecrement: (String) -> Void
    var onDelete: (String) -> Void

    private let tileHeight: CGFloat = 150

    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {

                // Add Hobby tile
                Button(action: onAddTapped) {
                    VStack(spacing: 12) {
                        Image(systemName: "plus")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundStyle(.white)
                        Text("Add Hobby")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: tileHeight)
                    .background(.black.opacity(0.4))
                    .clipShape(.rect(cornerRadius: 10))
                }

                // Hobby Tiles
                ForEach(Array(hobbies.values).sorted { $0.name < $1.name }, id: \.id) { hobby in
                    NavigationLink {
                        HobbyView(hobby: hobby) { id, newDescription in
                            if let existing = hobbies[id] {
                                hobbies[id] = Hobby(
                                    id: existing.id,
                                    name: existing.name,
                                    description: newDescription,
                                    dayStreak: existing.dayStreak
                                )
                            }
                        }
                    } label: {
                        HobbyTileView(
                            hobby: hobby,
                            isHighlighted: highlightedID == hobby.id,
                            onIncrement: { onIncrement(hobby.id) },
                            onDecrement: { onDecrement(hobby.id) },
                            onDelete: { onDelete(hobby.id) },
                            height: tileHeight
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding([.horizontal, .bottom])
        }
    }
}


// MARK: - HobbyTileView

struct HobbyTileView: View {
    let hobby: Hobby
    var isHighlighted: Bool = false
    var onIncrement: () -> Void
    var onDecrement: () -> Void
    var onDelete: () -> Void
    var height: CGFloat = 150

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.black.opacity(isHighlighted ? 0.4 : 0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white.opacity(isHighlighted ? 0.12 : 0.06), lineWidth: 1)
                )

            VStack {
                VStack {
                    Text(hobby.name)
                        .font(.headline)
                        .foregroundStyle(.white)

                    Text(String(hobby.dayStreak))
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.5))
                }
                .padding(.vertical)
                .animation(.default, value: hobby.dayStreak)

                HStack(spacing: 16) {
                    Button(action: onDecrement) {
                        Image(systemName: "minus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.white)
                    }
                    .buttonStyle(.plain)

                    Button(action: onIncrement) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.white)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.bottom, 12)
            }
            .padding(.horizontal, 8)
        }
        // put trash button on top, independently of the main content
        .overlay(alignment: .topTrailing) {
            Button(action: onDelete) {
                Image(systemName: "trash.fill")
                    .font(.system(size: 12, weight: .light))
                    .foregroundStyle(.white)
                    .opacity(0.2)
                    .padding(6)
                    .background(.black.opacity(0.1), in: .capsule)
            }
            .padding(8)
            .accessibilityLabel("Delete \(hobby.name)")
            .accessibilityHint("Removes this hobby")
        }
        .frame(maxWidth: .infinity)
        .frame(height: height)
        .clipShape(.rect(cornerRadius: 10))
        .contextMenu {
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}



// MARK: - Preview

#Preview {
    ContentView()
}

