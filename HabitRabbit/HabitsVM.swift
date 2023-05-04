//
//  HabitsVM.swift
//  HabitRabbit
//
//  Created by Julia Petersson  on 2023-04-20.
//

import Foundation
import Firebase

//BUG streak reset - kolla med reset toggle 

class HabitsVM : ObservableObject {
    
    let db = Firestore.firestore()
    let auth = Auth.auth()
    
    @Published var habits = [Habit]()

    @Published var dates: [String] = []
  //  @Published var donePerMonth: Int = 0

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
    

    
    
    func toggle(habit: Habit) {
        objectWillChange.send()

        guard let user = auth.currentUser else { return }
        let itemsRef = db.collection("users").document(user.uid).collection("habits")
        let date = Date()

        if let id = habit.id {
           

            if habit.done == false {
                itemsRef.document(id).updateData(["done": !habit.done])
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
        
        let habitRef = db.collection("users").document(user.uid).collection("habits").document(habitId)
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
                        //OBS måste nog sortera listan från firebase först om jag lägga till en funktioon där man kan lägga till ifall man har glömt bocka i dagen innan - för det funkar inte im det är på fel plats på datedrackern
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
        
        let habitRef = db.collection("users").document(user.uid).collection("habits").document(habitId)
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
    

    
    func filterByMonth(habit: Habit, choosenMonth: Date) -> [String] {
        var doneInMonth: [String] = []
        let calendar = Calendar.current
        let month = calendar.component(.month, from: choosenMonth)
        let year = calendar.component(.year, from: choosenMonth)
        
        
        let filteredDates = habit.dateTracker.filter { date in
            let monthNumber = Calendar.current.component(.month, from: date)
            return monthNumber == month
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        for date in filteredDates {
            doneInMonth.append(formatter.string(from: date))
       
        }
        print(habit.content, doneInMonth)
        return doneInMonth
    }
    

    
    
    func filterByWeek(habit: Habit, choosenWeek: Date) -> [String] {
            
        var doneInWeek: [String] = []
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.weekOfYear, .year], from: choosenWeek)
        let week = dateComponents.weekOfYear
        let year = dateComponents.year
//        let week = calendar.component(.weekOfYear, from: choosenWeek)
//        let year = calendar.component(.year, from: choosenWeek)
        var weekdays: [Date] = []
      
        // Get the start and end dates of the chosen week
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: choosenWeek) else {
            return []
        }
        
        let startDate = weekInterval.start
        let endDate = weekInterval.end
        
        // Create an array of dates for each day in the week
        var currentDate = startDate
        while currentDate <= endDate {
            weekdays.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        // Iterate over each date in the weekdays array
        for date in weekdays {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let dateString = formatter.string(from: date)
            
            // Iterate over each timestamp in the habit.dateTracker array
            for timestamp in habit.dateTracker {
                let timestampDate = timestamp
                let timestampDateString = formatter.string(from: timestampDate)
                
                // If the date strings match, append the date string to the doneInWeek array
                if dateString == timestampDateString {
                    doneInWeek.append(dateString)
                }
            }
        }
        print(habit.content, doneInWeek,"lala")
        return doneInWeek
    }





    func getDailyStatistic(choosenDay: Date, habit: Habit) -> Bool {
        
        var doneThatDay = false
        
        let calendar = Calendar.current
      
        let day = choosenDay
    print(day)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: day)
        
        
        print (dateString)
        
        for timestamp in habit.dateTracker {
            let timestampDate = timestamp
            let timestampDateString = formatter.string(from: timestampDate)
            if dateString == timestampDateString {
                doneThatDay = true
            }
          
        }
        print (habit.content, doneThatDay)
        return doneThatDay
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
