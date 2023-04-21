//
//  HabitsVM.swift
//  HabitRabbit
//
//  Created by Julia Petersson  on 2023-04-20.
//

import Foundation


class HabitsVM : ObservableObject {
    
    
   @Published var habits = [Habit]()
    
    init() {
   addMockData()
    }
        
        
    func addMockData(){
        habits.append(Habit(content: "Take a vitamin", done: false, category: "health nutrition", timesAweek: 7))
        habits.append(Habit(content: "Work out", done: false, category: "health sport", timesAweek: 3))
        
        
    }
    
}
