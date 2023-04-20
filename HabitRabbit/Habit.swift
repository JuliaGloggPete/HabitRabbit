//
//  Habit.swift
//  HabitRabbit
//
//  Created by Julia Petersson  on 2023-04-18.
//

import Foundation
import FirebaseFirestoreSwift

struct Habit : Identifiable {
   // @DocumentID var id : String?
    var id = UUID()
    var content : String
    var done : Bool = false
    var category : String = ""
    var timesAweek : Int
    
    private var unformatedDate = Date()
   private let dateFormatter = DateFormatter()
    

    //var tracker : [String] = []
    init(
        //id: String? = nil,
        content: String, done: Bool, category: String, timesAweek: Int) {
        //self.id = id
        self.content = content
        self.done = done
        self.category = category
        dateFormatter.dateStyle = .medium
            self.timesAweek = timesAweek
      //  self.tracker = tracker
    }
    
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
