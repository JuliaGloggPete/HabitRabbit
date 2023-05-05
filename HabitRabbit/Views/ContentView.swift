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
    @StateObject private var notificationManager = NotificationManager()
    
    var body: some View {
//        ZStack{
//            Color (red: 244/256, green:221/256,blue: 220/256)
//                .ignoresSafeArea()
            if !signedIn {
                SignInView(signedIn: $signedIn)
                
            }else {
                HabitListView(notificationManager: notificationManager)
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
    
    @ObservedObject var notificationManager: NotificationManager
    
    @ViewBuilder
    var infoOverlayView: some View{
        switch notificationManager.authorizationStatus{
            
                
            case .denied:
            
                InfoOverlayView(
                    infoMessage: "PleaseEnable Notifiacation Permission in Settings",
                    buttonTitle: "Settings",
                    systemImageName: "gear",
                    action: {
                        if let url = URL(string: UIApplication.openSettingsURLString),
                           UIApplication.shared.canOpenURL(url){
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            
                            
                        }
                    }
                )
            default:
                EmptyView()
            }
        }
    
    
    @EnvironmentObject var habitList : HabitsVM
    
    @State var showingHabitDetails = false
    @State var selectedHabit : Habit?
    @State var showingStatistics = false
    @State var showToggle = true
    
    var body: some View {
        
        NavigationView{
            
            VStack {
                
                HStack{
                    
                    List() {
                        
                        ForEach(habitList.habits) { habit in
     
                            Section{
                                
                                HStack{
                                    HabitsTextView(habit: habit)
                                    
                                    Spacer()
                                    HabitsToggleView(habit: habit)
                                        .onChange(of: habit.done) { _ in
                                           // habitList.toggle(habit: habit)
                                            habitList.streakCounter(habit: habit)
                                            habitList.listen2FS()
                                        }
                                    
                                }
                                
                                Button(action: {
                             
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
       
                    .listStyle(InsetGroupedListStyle())
                    .overlay(infoOverlayView)
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
                    .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)){ _ in
                        notificationManager.reloadAuthorizationStatus()
                    }
//                    .onChange(of: showToggle) { newValue in
//                        NavigationLink(destination: HabitDetailsView(habit: habit))
//                    }
                    
                }
                VStack{
                    Image("Rabbit")
                        .resizable()
                        .frame(width: 200, height: 200)
                    Button(action: {showingStatistics = true
                        
                    })
                    {
                        Text("Statistics")
                        
                    }
                }
                
            }
            
            .navigationTitle("Habit")
            .navigationBarItems(trailing: NavigationLink(destination: HabitDetailsView(   notificationManager: notificationManager)){
                Image(systemName: "plus.circle")
            })
        }
        .sheet(isPresented: $showingHabitDetails) {
            NavigationView {
                HabitDetailsView(habit: selectedHabit, notificationManager: notificationManager)
                    .navigationBarItems(trailing: Button("Done") {
                        self.showingHabitDetails = false
                    })
            }
        }
        .sheet(isPresented: $showingStatistics) {
            NavigationView {
           StatisticsView()
                    .navigationBarItems(trailing: Button("Back") {
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
   

//
//struct ContentView_Previews: PreviewProvider {
//    @EnvironmentObject var habitList: HabitsVM
//    static var previews: some View {
//        HabitListView(notificationManager: NotificationManager())
//    }
//}


struct HabitsTextView: View {
    let habit: Habit
    @EnvironmentObject var habitList: HabitsVM
    
    var body: some View {
    
        
        // göra om till en button så jag kan ta bort Editknappen som inte funkar hundra
            HStack{
                
                Text(String(habit.currentStreak))
                    .fontWeight(.semibold)

                
                Text(habit.content)
                    .foregroundColor(.black)
                if habit.currentStreak >= 5 {
                    let carrots = (habit.currentStreak / 5)
                    ForEach(1...carrots, id: \.self) { _ in
                        Image(systemName: "carrot.fill")
                            .foregroundColor(.orange)
                    }
                }


            }.onAppear{habitList.resetToggle(habit: habit); habitList.streakCounter(habit: habit)}
    }
    }


struct HabitsToggleView: View {
    let habit: Habit
    
    @EnvironmentObject var habitList: HabitsVM
    //undo=?
    var body: some View {
        Button(action: {
            habitList.toggle(habit: habit)
        
            
        }) {
            
            //antingen göra nåt när man trycker på done igen så att den tas bort eller låsa den så man inte kan trycker igen när man har tryckt - om dagens datum är i done så är image osynlig och text fet t.ex eller en delete funktion
 
            
            Image(systemName: habit.done ? "checkmark.seal.fill" : "seal" )
                .foregroundColor(Color(red: 192/256, green:128/256,blue: 102/256))
            
        }
        
       
    }
    
}

