//
//  ContentView.swift
//  HabitRabbit
//
//  Created by Julia Petersson  on 2023-04-18.
//

import SwiftUI
import Firebase

struct ContentView: View {
    let db = Firestore.firestore()
    
   // var habits = Habit()
    
    /*[Habit(content: "Go for a walk every day",done:false ,category: "",tracker: [""]),
                  Habit(content:"Take a vitamin every day" ,done:false ,category: "",tracker: [""]),
                  Habit(content: "call a friend/relative" ,done:false ,category: "",tracker: [""])]
    */
    var body: some View {
        VStack {
            
            Text("hej")
            
          //  List() {
            //    ForEach(habits, id: \.self ) { habit in
                    
                    Text("habit")
            //    }
                
           // }
          
        }.onAppear(){
            db.collection("test").addDocument(data: ["name": "Julia"] )
        }
       
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
