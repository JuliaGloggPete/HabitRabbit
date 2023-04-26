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

    //den biten hör nog inte till här tror jag
    private var unformatedDate = Date()
  
        private static let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter
        }()
    

    //var tracker : [String] = []
    init(
        //id: String? = nil,
        content: String, done: Bool, category: String, timesAWeek: Int) {
        //self.id = id
        self.content = content
        self.done = done
        self.category = category
      //  dateFormatter.dateStyle = .medium
        self.timesAWeek = timesAWeek
      //  self.tracker = tracker
    }

    
    var initialDate : String {
        
    
        return Habit.dateFormatter.string(from: unformatedDate)
        
    }
    
 
    
    
    
}
