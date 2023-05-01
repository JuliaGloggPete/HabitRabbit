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

    @Published var dates: [String] = []

    func update(habit: Habit, with content: String, with category: String, with timesAWeek: Int){
        
        if let index = habits.firstIndex(of: habit){
            habits[index].content = content
            habits[index].category = category
            habits[index].timesAWeek = timesAWeek
            
            
        }}
    
    func deleteHabit(index: Int){
        
        guard let user = auth.currentUser else {return}
        let itemsRef = db.collection("users").document(user.uid).collection("habits")
        
        let habit = habits[index]
        if let id = habit.id{
            itemsRef.document(id).delete()
            
            
        }
        
    }
    
//    func toggle(habit: Habit){
//        
//        guard let user = auth.currentUser else {return}
//        let itemsRef = db.collection("users").document(user.uid).collection("habits")
//        let date = Date()
//        
//        if let id = habit.id{
//            
//            itemsRef.document(id).updateData(["done" : !habit.done])
//            
//            if habit.done ==  false {
//                if !habit.dateTracker.contains(where: { Calendar.current.isDate($0, inSameDayAs: date) }) {
//                    itemsRef.document(id).updateData(["dateTracker" : FieldValue.arrayUnion([date])])
//                }}
//            
//        }
//    
//    }
    
    func toggle(habit: Habit) {
        objectWillChange.send()

        guard let user = auth.currentUser else { return }
        let itemsRef = db.collection("users").document(user.uid).collection("habits")
        let date = Date()

        if let id = habit.id {
            itemsRef.document(id).updateData(["done": !habit.done])

            if habit.done == false {
                if !habit.dateTracker.contains(where: { Calendar.current.isDate($0, inSameDayAs: date) }) {
                    itemsRef.document(id).updateData(["dateTracker": FieldValue.arrayUnion([date])])
                }
            }
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
    

    func streakCounter(habit: Habit) {
        guard let user = Auth.auth().currentUser, let habitId = habit.id else { return }
        
        let habitRef = Firestore.firestore().collection("users").document(user.uid).collection("habits").document(habitId)
        habitRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                if let dateTracker = data?["dateTracker"] as? [Timestamp] {
                    let today = Date()
                    let calendar = Calendar.current
                    var currentStreak = 0
                    if dateTracker.contains(where: { calendar.isDate($0.dateValue(), inSameDayAs: today) }){
                        currentStreak += 1}
                    
                    
                    // Check if habit was done yesterday and compute streak
                    if let yesterday = calendar.date(byAdding: .day, value: -1, to: today),
                       dateTracker.contains(where: { calendar.isDate($0.dateValue(), inSameDayAs: yesterday) }) {
                        currentStreak += 1
                        
                        // Continue checking back one day at a time
                        var currentDay = yesterday
                        while let previousDay = calendar.date(byAdding: .day, value: -1, to: currentDay),
                              dateTracker.contains(where: { calendar.isDate($0.dateValue(), inSameDayAs: previousDay) }) {
                            currentStreak += 1
                            currentDay = previousDay
                        }
                    }
      
                    habitRef.updateData(["currentStreak": currentStreak])
                }
            } else {
                print("Habit document does not exist")
            }
        }
    }
    
    func resetToggle(habit: Habit) {
        guard let user = Auth.auth().currentUser, let habitId = habit.id else { return }
        
        let habitRef = Firestore.firestore().collection("users").document(user.uid).collection("habits").document(habitId)
        habitRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                if let dateTracker = data?["dateTracker"] as? [Timestamp] {
                    let today = Date()
                    let calendar = Calendar.current
                    if !dateTracker.contains(where: { calendar.isDate($0.dateValue(), inSameDayAs: today) }){
                        habitRef.updateData(["done" : false])}
                }
                }
            }
            
        }
    
    func fetchDateTracker(habit: Habit) {
        guard let user = Auth.auth().currentUser, let habitId = habit.id else { return }
        
        let habitRef = Firestore.firestore().collection("users").document(user.uid).collection("habits").document(habitId)
        habitRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                if let dateTracker = data?["dateTracker"] as? [Timestamp] {
                    for timestamp in dateTracker {
                        let date = timestamp.dateValue()
                        print("\(habit.content): \(date)")
                    }
                }
            } else {
                print("Habit document does not exist")
            }
        }
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
