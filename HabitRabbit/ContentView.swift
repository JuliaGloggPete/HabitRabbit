//
//  ContentView.swift
//  HabitRabbit
//
//  Created by Julia Petersson  on 2023-04-18.
//

import SwiftUI
import Firebase

struct ContentView : View {
    
     @State var signedIn = false

    
    var body: some View {
        
        if !signedIn {
            SignInView(signedIn: $signedIn)
            
        }else {
            HabitListView()
        }
        
    }
    
}


struct SignInView : View {
    @Binding var signedIn : Bool
    var auth = Auth.auth()
    
    var body: some View {
        
        Button(action:{
            auth.signInAnonymously(){ result, error in
                if let error = error {
                    print("error signing in")
                    
                } else{
                    signedIn = true
                    
                } }}){
            
            
            Text("Sign in")
        }
        
        
    }
    
    
}


struct HabitListView: View {


    @EnvironmentObject var habitList : HabitsVM

    var body: some View {
            NavigationView{
                
                VStack {
                    HStack{
                        
                        List() {
                            
                            ForEach(habitList.habits) { habit in
                                
                                HStack{
                                    HabitsTextView(habit: habit)
                                    HabitsToggleView(habit: habit)
                                   
                                    
                                
                                }
                                
                            
                            
                            
                        }
                    }}
               
                        

                    .navigationTitle("Habit")
                    .navigationBarItems(trailing: NavigationLink(destination: HabitDetailsView()){
                        Image(systemName: "plus.circle")
                    })
                }
            
                    .onAppear(){
                        habitList.listen2FS()
                       
                     //   habitList.resetToggle()
                        
                        
                    }
                
                
            }
            
            
            
        }
    
        

    }
        
struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            HabitListView()
        }
    }


//struct StreakView: View {
//    let habit: Habit
//    @EnvironmentObject var habitList: HabitsVM
//    
//    var body: some View {
//        if let habitID = habit.id,
//           let currentStreak = habitList.currentStreaks[habitID]
//          // let longestStreak = habitList.longestStreaks[habitID]
//        {
//            Text("Current streak: \(currentStreak)")
//       
//        } else {
//            Text("Streak data not available")
//        }
//    }
//}

struct HabitsTextView: View {
    let habit: Habit
    @EnvironmentObject var habitList: HabitsVM
    
    var body: some View {
     
        Text(String(habit.currentStreak))
            .onAppear() {
                habitList.streakCounter(habit: habit)
            }
        ;
                Text(habit.content)
                    .foregroundColor(habit.category == "Nutrition/Health" ? .blue : habit.category == "Nutrition/Health" ? .green : .black)
                    .listRowBackground(habit.category == "Sports/Health" ? Color.yellow : habit.category == "Sports/Health" ? Color.blue : Color.white)
        
        
                }
}

struct HabitsToggleView: View {
    let habit: Habit
    
    @EnvironmentObject var habitList: HabitsVM
    
    var body: some View {
        Button(action: {
            habitList.toggle(habit: habit)
          
        }) {
            Image(systemName: habit.done ? "checkmark.seal.fill" : "seal" )
                .foregroundColor(.cyan)
                
        }
    }}

