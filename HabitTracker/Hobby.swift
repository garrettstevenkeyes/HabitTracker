//
//  Hobby.swift
//  HabitTracker
//
//  Created by Garrett Keyes on 12/2/25.
//

import Foundation

struct Hobby: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
    let dayStreak: Int
}
