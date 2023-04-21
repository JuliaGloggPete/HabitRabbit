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
    
   @StateObject var habitList = HabitsVM()
    // detta görs säkert om sen när det är fb
    
    var body: some View {
        NavigationView{
            VStack {
                
                
                
                //List under list för eventuellt subclass om done som heter dagens dag och false or true o sen dagens datum
                // minus -1 osv för att visa progressen
                
                List() {
                    ForEach(habitList.habits) { habit in
                        NavigationLink(destination: HabitDetailsView(habit: habit, habits: habitList)){
                            HabitsRowView(habit: habit)}
                    }
                }
                
            }
            .navigationTitle("Habit")
            .navigationBarItems(trailing: NavigationLink(destination: HabitDetailsView(habits: habitList)){
                Image(systemName: "plus.circle")
            })
            .onAppear(){
                //db.collection("test").addDocument(data: ["name": "Julia"] )
            }
            
                                }
                                
        /*      func saveNewHabit(habitDescription: String){
         let habit = Habit(content: habitDescription)
         
         
         }
         */
    }
}
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }


struct HabitsRowView: View {
    let habit : Habit
    
    var body: some View {
        
      
        
        HStack{
            
            Text(habit.content)
                .foregroundColor(habit.category == "health sport" ? .blue : habit.category == "health nutrition" ? .green : .black)
                .listRowBackground(habit.category == "health sport" ? Color.yellow : habit.category == "health nutrition" ? Color.blue : Color.white)
            Spacer()
            Text(" times \(habit.timesAweek)")
            Spacer()
            Image(systemName: habit.done ?  "checkmark.seal.fill" : "seal" )
                .foregroundColor(.cyan)
        }
    }
}
