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
    
    func toggle(habit: Habit){
        
        guard let user = auth.currentUser else {return}
        let itemsRef = db.collection("users").document(user.uid).collection("habits")
       
        
        if let id = habit.id{
        
            itemsRef.document(id).updateData(["done" : !habit.done])
            
         
            let isDone = habit.done
            
            if isDone {
                let doneDateRef = itemsRef.document(id).collection("doneDate")
                let currentDate = Date()
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                let dateString = formatter.string(from: currentDate)
                
                // Check if the current date already exists in the doneDate subcollection
                doneDateRef.whereField("date", isEqualTo: dateString).getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print("Error getting doneDate subcollection: \(error.localizedDescription)")
                        return
                    }
                    
                    if let querySnapshot = querySnapshot, !querySnapshot.isEmpty {
                        // The current date already exists in the doneDate subcollection, so do nothing
                    } else {
                        // The current date does not exist in the doneDate subcollection, so add it
                        doneDateRef.addDocument(data: ["date": dateString])
                    }
                }
            }
            
          //  itemsRef.document(id).collection("doneDate").addDocument(data: ["date" : "\(date)"])
        }
    }
    
    func showStreak(habit:Habit){
           guard let user = auth.currentUser else {return}
           let itemsRef = db.collection("users").document(user.uid).collection("habits")
           
       
               if let id = habit.id {
                   let doneDateRef = itemsRef.document(id).collection("doneDate")
                   
                   doneDateRef.order(by: "date", descending: true).getDocuments { (querySnapshot, error) in
                       if let error = error {
                           print("Error getting doneDate subcollection: \(error.localizedDescription)")
                           return
                       }
                       
                       guard let documents = querySnapshot?.documents else {
                           print("No documents found in doneDate subcollection.")
                           return
                       }
                       
                       let formatter = DateFormatter()
                       formatter.dateStyle = .medium
                       
                       var currentStreak = 0
                       var longestStreak = 0
                       
                       for (index, document) in documents.enumerated() {
                           // Get the date from the document
                           guard let dateString = document.data()["date"] as? String,
                                 let date = formatter.date(from: dateString)
                           else {
                               print("Invalid date format in document \(document.documentID). Skipping document.")
                               continue
                           }
                           
                           
                           var currentDate = Date()
                           var formatedCurrentDate = formatter.string(from: currentDate)
                           let habitID = habit.id ?? ""
                           
                           if index == 0 || formatedCurrentDate == documents[0].data()["date"] as? String {    currentStreak += 1
                           } else {
                               // If the current date is not consecutive, update the longest streak and reset the current streak
                               if currentStreak > longestStreak {
                                   longestStreak = currentStreak
                               }
                               currentStreak = 1
                           }
                           
                           self.currentStreaks[habitID] = currentStreak
                           self.longestStreaks[habitID] = longestStreak
                           
                           
                           print("Current streak: \(currentStreak)")
                           print("Longest streak: \(longestStreak)")
                       }}
           }}


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
    func listen2FS (){
        
        guard let user = auth.currentUser else {return}
        let itemsRef = db.collection("users").document(user.uid).collection("habits")
    
        
       itemsRef.addSnapshotListener() {
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
