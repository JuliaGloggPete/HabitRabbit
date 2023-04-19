//
//  Habit.swift
//  HabitRabbit
//
//  Created by Julia Petersson  on 2023-04-18.
//

import Foundation

struct Habit {
    
    var content : String
    var done : Bool = false
    var category : String = ""
    
    private var unformatedDate = Date()
    private let dateFormatter = DateFormatter()
    

    var tracker : [String] = []
    
  /*  init(content: String, done: Bool, category: String, tracker: [String]) {
        self.content = content
        self.done = done
        self.category = category
        self.tracker = tracker
        dateFormatter.dateStyle = .medium
    }*/
    
    var date : String {
        
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: unformatedDate)
        
    }
    
    
    
}
