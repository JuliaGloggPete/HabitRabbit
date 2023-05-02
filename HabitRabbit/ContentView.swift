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
//        ZStack{
//            Color (red: 244/256, green:221/256,blue: 220/256)
//                .ignoresSafeArea()
            if !signedIn {
                SignInView(signedIn: $signedIn)
                
            }else {
                HabitListView()
            }
            
        }
  //  }
}


struct SignInView : View {
    @Binding var signedIn : Bool
    var auth = Auth.auth()
    
    var body: some View {
 ZStack{
//           Color (red: 244/256, green:221/256,blue: 220/256)
//         .ignoresSafeArea()
           // ZStack {
                Image("Bunny")
                   .resizable()
                   .aspectRatio(contentMode: .fill)
                   .ignoresSafeArea()
                    //.frame(width: .greatestFiniteMagnitude)
                    //.frame(width: 200, height: 200)
                Button(action:{
                    auth.signInAnonymously(){ result, error in
                        if let error = error {
                            print("error signing in")
                            
                        } else{
                            signedIn = true
                            
                        } }}){
                            
                            
                            Text("Sign in")
                                .foregroundColor(Color(red: 192/256, green:128/256,blue: 102/256))
                        }.buttonStyle(.bordered)
            }
        }
  //  }
}

struct HabitListView: View {
    
    
    @EnvironmentObject var habitList : HabitsVM
    @StateObject private var notificationManager = NotificationManager()
    @State var showingHabitDetails = false
    @State var selectedHabit : Habit?
    
    var body: some View {
        
        NavigationView{
            
            VStack {
                
                HStack{
                    
                    List() {
                        
                        ForEach(habitList.habits) { habit in
                            //                                NavigationLink(destination: HabitDetailsView(habit: habit)) {
                            Section{
                                
                                HStack{
                                    HabitsTextView(habit: habit)
                                    
                                    Spacer()
                                    HabitsToggleView(habit: habit)
                                        .onChange(of: habit.done) { _ in
                                            habitList.toggle(habit: habit)
                                            habitList.streakCounter(habit: habit)
                                            habitList.listen2FS()
                                        }
                                    
                                }
                                
                                Button(action: {
                                    // lägga till en bool som trigger Navigationlink
                                    selectedHabit = habit
                                    showingHabitDetails = true
                                    
                                    //NavigationLink(destination: HabitDetailsView(habit: habit))
                                    
                                }){
                                    Label("Edit", systemImage: "pencil")
                                }
                                
                            }
                        }
                        
                        .onDelete(){
                            indexSet in
                            for index in indexSet{
                                
                                habitList.deleteHabit(index: index)
                                
                                
                            }
                        }
                        
                        .navigationTitle("Habits")
                       .foregroundColor(Color(red: 244/256, green:221/256,blue: 220/256))
                        .cornerRadius(10)
                        .colorMultiply(Color(red: 244/256, green:221/256,blue: 220/256))
                        
                    }
                    //                        .toolbar {
                    //                            ToolbarItem(placement: .navigationBarTrailing) {
                    //                                EditButton()
                    //                            }
                    //                        }
                    .listStyle(InsetGroupedListStyle())
                    .onAppear(perform: notificationManager.reloadAuthorizationStatus)
                    .onChange(of: notificationManager.authorizationStatus){ authorizationStatus in
                        switch authorizationStatus {
                        case .notDetermined:
                            notificationManager.requestAuthorization()
                            
                        case .authorized:
                            
                            notificationManager.reloadLocalNotificaitons()
                            
                        default:
                            break
                            
                        }
                        
                    }
                    
                }
                Image("Rabbit")
                    .resizable()
                    .frame(width: 200, height: 200)
            }
            
            
            .navigationTitle("Habit")
            .navigationBarItems(trailing: NavigationLink(destination: HabitDetailsView()){
                Image(systemName: "plus.circle")
            })
        }
        .sheet(isPresented: $showingHabitDetails) {
            NavigationView {
                HabitDetailsView(habit: selectedHabit)
                    .navigationBarItems(trailing: Button("Done") {
                        self.showingHabitDetails = false
                    })
            }
        }
        .accentColor(Color(red: 192/256, green:128/256,blue: 102/256))
        .onAppear(){
            habitList.listen2FS()
        }
        
    }
       
}
   


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        HabitListView()
//    }
//}


struct HabitsTextView: View {
    let habit: Habit
    @EnvironmentObject var habitList: HabitsVM
    
    var body: some View {
    
            HStack{
                
                Text(String(habit.currentStreak))
                    .fontWeight(.semibold)

                
                Text(habit.content)
                    .foregroundColor(.black)
//                    .foregroundColor(habit.category == "Nutrition/Health" ? .blue : habit.category == "Nutrition/Health" ? .green : .black)
//                    .listRowBackground(habit.category == "Sports/Health" ? Color.yellow : habit.category == "Sports/Health" ? Color.blue : Color.white)
                    
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
        
       
    }
    
}

