//
//  Habit.swift
//  HabitRabbit
//
//  Created by Julia Petersson  on 2023-04-18.
//

import Foundation
import FirebaseFirestoreSwift


struct Habit : Identifiable, Equatable, Codable {
    
    @DocumentID var id : String?
   // var id = UUID()
    var content : String
    var done : Bool = false
    var category : String = ""
    var timesAWeek : Int
    var dateTracker : [Date]
    var currentStreak: Int 
    var initialDate : Date
   // var setReminder : Bool = false
    
    init(id: String? = nil, content: String, done: Bool, category: String, timesAWeek: Int, dateTracker: [Date], currentStreak: Int, initialDate: Date) {
        self.id = id
        self.content = content
        self.done = done
        self.category = category
        self.timesAWeek = timesAWeek
        self.dateTracker = dateTracker
        self.currentStreak = currentStreak
        self.initialDate = initialDate
       // self.setReminder = setReminder
    }
    
    //den biten hör nog inte till här tror jag
//    private var unformatedDate = Date()
//
//        private static let dateFormatter: DateFormatter = {
//            let formatter = DateFormatter()
//            formatter.dateStyle = .medium
//            return formatter
//        }()
//

//    init(
//        content: String, done: Bool, category: String, timesAWeek: Int) {
//        //self.id = id
//        self.content = content
//        self.done = done
//        self.category = category
//      //  dateFormatter.dateStyle = .medium
//        self.timesAWeek = timesAWeek
//      //  self.tracker = tracker
//    }

    
//    var initialDate : String {
//
//
//        return Habit.dateFormatter.string(from: unformatedDate)
//
//    }
//
//
    
    
    
}
