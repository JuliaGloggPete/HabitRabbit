//
//  HabitsVM.swift
//  HabitRabbit
//
//  Created by Julia Petersson  on 2023-04-20.
//

import Foundation
import Firebase


class HabitsVM : ObservableObject {
    
    let db = Firestore.firestore()
   @Published var habits = [Habit]()
    
    init() {
   addMockData()
    }
        
        
    func addMockData(){
        habits.append(Habit(content: "Take a vitamin", done: false, category: "Health nutrition", timesAWeek: 7))
        habits.append(Habit(content: "Work out", done: false, category: "Health sport", timesAWeek: 3))
        
        
    }
    
    func update(habit: Habit, with content: String, with category: String, with timesAWeek: Int){
        
        if let index = habits.firstIndex(of: habit){
            habits[index].content = content
            habits[index].category = category
            habits[index].timesAWeek = timesAWeek
            
            
        }}
    
    
    
    func listen2FS (){
        db.collection("NewHabit").addSnapshotListener() {
            snapshot, err in
            
            guard let snapshot = snapshot else {return}
            
            if let err = err {
                print("error getting document \(err)")
            } else {
                
                self.habits.removeAll()
                
                for document in snapshot.documents{
                    
                    do{
                        
                        let habit = try document.data(as : Habit.self)
                        self.habits.append(habit)
                    } catch {
                        print("Error")
                        
                    }
                    
                    
                    
                    
                    
                }
                
            }
            
            
        }
    }
    
    
    
    
    
    
}
