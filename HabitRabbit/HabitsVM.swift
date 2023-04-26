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
    let auth = Auth.auth()
    
    @Published var habits = [Habit]()
    @Published var currentStreaks = [String: Int]()
    @Published var longestStreaks = [String: Int]()

    func update(habit: Habit, with content: String, with category: String, with timesAWeek: Int){
        
        if let index = habits.firstIndex(of: habit){
            habits[index].content = content
            habits[index].category = category
            habits[index].timesAWeek = timesAWeek
            
            
        }}
    
    func toggle(habit: Habit){
        
        guard let user = auth.currentUser else {return}
        let itemsRef = db.collection("users").document(user.uid).collection("habits")
        let date = Date()
        
        if let id = habit.id{
            
            itemsRef.document(id).updateData(["done" : !habit.done])
            
            if habit.done ==  false {
                if !habit.dateTracker.contains(where: { Calendar.current.isDate($0, inSameDayAs: date) }) {
                    itemsRef.document(id).updateData(["dateTracker" : FieldValue.arrayUnion([date])])
                }}
            
        }
        
        
    }
    

    func streak(habit: Habit){
        
        guard let user = auth.currentUser else {return}
        let itemsRef = db.collection("users").document(user.uid).collection("habits")
        let date = Date()
        
        if let id = habit.id{
            
            itemsRef.document(id).collection("dateTracker")
            
           // itemsRef.document(id).updateData(["done" : !habit.done])
           
        }
        
        
    }
    
    
    
    func saveHabit(habit: Habit) {
        
        guard let user = auth.currentUser else {return}
        let itemsRef = db.collection("users").document(user.uid).collection("habits")
        
        
        
        if let id = habit.id{
            itemsRef.document(id).updateData(["content": habit.content, "category": habit.category, "timesAWeek": habit.timesAWeek])
            
            
            
        } else{
            do {
                try itemsRef.addDocument(from: habit)
                //    habitList.habits.append(newHabit)
            } catch {
                print("Errorroro")
            }
            
        }
        
    }
    
    
    func streakUpdate() {
        
        
    }
    
    
    
    
    func listen2FS (){
        
        guard let user = auth.currentUser else {return}
        
        let itemsRef = db.collection("users").document(user.uid).collection("habits")
          
        itemsRef.addSnapshotListener() {
            snapshot, err in
            
            guard let snapshot = snapshot else {return}
            
            if let err = err {
                print("error\(err)")
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
