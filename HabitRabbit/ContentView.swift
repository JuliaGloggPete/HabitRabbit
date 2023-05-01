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
        ZStack{
            Color (red: 244/256, green:221/256,blue: 220/256)
                .ignoresSafeArea()
            if !signedIn {
                SignInView(signedIn: $signedIn)
                
            }else {
                HabitListView()
            }
            
        }
    }
}


struct SignInView : View {
    @Binding var signedIn : Bool
    var auth = Auth.auth()
    
    var body: some View {
        ZStack{
            Color (red: 244/256, green:221/256,blue: 220/256)
                .ignoresSafeArea()
            
            Button(action:{
                auth.signInAnonymously(){ result, error in
                    if let error = error {
                        print("error signing in")
                        
                    } else{
                        signedIn = true
                        
                    } }}){
                        
                        
                        Text("Sign in")
                            .foregroundColor(Color(red: 192/256, green:128/256,blue: 102/256))
                    }
        }
        
    }
}

struct HabitListView: View {
    
    
    @EnvironmentObject var habitList : HabitsVM
    @StateObject private var notificationManager = NotificationManager()
    
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
                            }
                            .listStyle(InsetGroupedListStyle())
                            .onAppear(perform: notificationManager.reloadAuthorizationStatus)
                            .onChange(of: notificationManager.authorizationStatus){ authorizationStatus in
                                switch authorizationStatus {
                                case .notDetermined:
                                    notificationManager.requestAuthorization()
                                    
                                case .authorized:
                                    
                                    notificationManager.reloadLocalNotificaitons()
                                    
                                    break
                                default:
                                    break
                                    
                                    
                                    
                                }
                                
                            }
                            
                            
                        
                   }
                    
                }
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
    
    


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HabitListView()
    }
}


struct HabitsTextView: View {
    let habit: Habit
    @EnvironmentObject var habitList: HabitsVM
    
    var body: some View {
        ZStack{
            Color (red: 244/256, green:221/256,blue: 220/256)
            HStack{
                Text(String(habit.currentStreak))
                    .fontWeight(.semibold)
                    .onAppear() {
                        habitList.streakCounter(habit: habit)
                        habitList.resetToggle(habit: habit)
                    }
                ;
                Text(habit.content)
                    .foregroundColor(habit.category == "Nutrition/Health" ? .blue : habit.category == "Nutrition/Health" ? .green : .black)
                    .listRowBackground(habit.category == "Sports/Health" ? Color.yellow : habit.category == "Sports/Health" ? Color.blue : Color.white)
            }
        }
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

