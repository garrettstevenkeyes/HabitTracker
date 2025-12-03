//
//  HobbyView.swift
//  HabitTracker
//
//  Created by Garrett Keyes on 12/2/25.
//

import SwiftUI

struct HobbyView: View {
    let hobby: Hobby
    
    
    var body: some View {
        
        ScrollView{
            VStack {
                Text(hobby.description)

            }
            .padding(.bottom)
        }
    }
    
    init(hobby:Hobby) {
        self.hobby = hobby
    }
}


struct HobbyHeaderView: View {
    let hobby: Hobby
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Mission Highlights")
                .font(.title.bold())
                .padding(.bottom, 5)
            Text(hobby.description)
        }
        .padding(.horizontal)
    }
}

#Preview {
    let hobby = Hobby(id: "yoga", name: "Yoga", description: "Morning stretches to make me feel good.", dayStreak: 2)
    HobbyView(hobby: hobby)
}
