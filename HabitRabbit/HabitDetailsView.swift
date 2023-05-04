//
//  HabitDetailsView.swift
//  HabitRabbit
//
//  Created by Julia Petersson  on 2023-04-19.
//

import SwiftUI

import Firebase

struct HabitDetailsView: View {
    let db = Firestore.firestore()
    var habit : Habit?
    @ObservedObject var notificationManager: NotificationManager
    @EnvironmentObject var habitList : HabitsVM
    @State var content : String = ""
    @State var category : String = "Category"
    @State var done : Bool = false
    @State var timesAWeek : Int = 7
    @State var setReminder : Bool = true
    @State var today = Date()

    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {

            VStack{
                HStack{
                
                    TextField("Name of habit: ", text: $content)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        //.frame(alignment: .center)
                        .onChange(of: content) { newValue in
                            if content.count > 60 {
                                content = String(content.prefix(60))
                            }
                        }}
                Spacer()
          
                Menu{
                    ForEach(1..<8) { number in
                        Button(action: {timesAWeek = number}, label: {
                            Text("\(number)")
                            
                        })
                    }
                    
                } label: {
                    Label(title: { Text("\(timesAWeek) Times a week") }, icon: { Image(systemName: "figure.run") })
                }
                
                
                Menu{
                    Button(action: {category = "Sports/Health"}, label: {
                        Text("Sports/Health")
                        
                    })
                    Button(action: {category = "Nutrition/Health"}, label: {
                        Text("Nutrition/Health")
                        
                    })
                    Button(action: {category = "Knowledge"}, label: {
                        Text("Knowledge")
                        
                    })
                    Button(action: {category = "Well-being"}, label: {
                        Text("Well-being")
                        
                    })
                    Button(action: {category = "Enviroment"}, label: {
                        Text("Enviroment")
                        
                    })
                    Button(action: {category =  "Social skills"}, label: {
                        Text("Social skills")
                        
                    })
                    Button(action: {category = "Other"}, label: {
                        Text("Other")
                        
                    })
                    
                }label: {
                    Label(title: {Text("\(category)")},
                          
                          icon:{Image(systemName: "hare")}
                    )
                }
                
                Section{
                    
                        VStack{
                        
                            DatePicker("Daily Reminder:", selection: $today, displayedComponents: [.hourAndMinute])
                                .padding()
                                .foregroundColor(Color(red: 192/256, green:128/256,blue: 102/256))
                            
                            
                            Toggle("Set reminder", isOn: $setReminder)
                                .padding()
                                .foregroundColor(Color(red: 192/256, green:128/256,blue: 102/256))
       
                    }
                    .backgroundStyle(.primary)
                }
                .frame(width: 240, height: 140)
                .background(Color(red: 244/256, green:221/256,blue: 220/256))
                .cornerRadius(15)
                
                    Spacer()
                    //  En sammanställning av användarens utförda vanor för varje dag, vecka och månad.
                
                Menu{
                    Button(action: {content = "Go for a 30min walk"; category = "Sports/Health"; timesAWeek = 7
                    }, label: {
                        Text("Go for a 30min walk")
                        
                    })
                    Button(action: {content = "Eat fruit/vegetables"; category = "Nutrition/Health"; timesAWeek = 7
                    }, label: {
                        Text("Eat fruit/vegetables")
                        
                    })
                    Button(action: {content = "Learn a new word"; category = "Knowlege"; timesAWeek = 7
                    }, label: {
                        Text("Learn a new word")
                        
                    })
                    
                    
                }label: {
                    Label(title: {Text("Suggestions")},
                          
                          icon:{Image(systemName: "hare")}
                    )
                }
               
                
        }
            .accentColor(Color(red: 192/256, green:128/256,blue: 102/256))
        .onAppear(perform: setContent)
        .onDisappear{notificationManager.reloadLocalNotificaitons()}
        .navigationBarTitle("Habit Detail", displayMode: .inline)
        .navigationBarItems(trailing: Button("Save"){
            if let habit = habit{
                habitList.saveHabit(habit:habit)}
            else
            {
                
                let date = Date()
                let newHabit = Habit(content: content, done: false, category: category, timesAWeek: timesAWeek, dateTracker: [],currentStreak: 0,initialDate: date)
                habitList.saveHabit(habit: newHabit)
                
                if setReminder{
                    
                    let dateComponent = Calendar.current.dateComponents([.hour, .minute], from: today)
                    
                    guard let hour = dateComponent.hour, let minute = dateComponent.minute else{ return}
                    
                    notificationManager.createLocalNotification(title: content, hour: hour, minute: minute){
                        error in
                        if error == nil {
                            DispatchQueue.main.async {
                                print("saved")
                            }
                        }
                    }
                    
                }
            }
            presentationMode.wrappedValue.dismiss()
            
        })
    }
    
    private func setContent() {
        
        if let habit = habit {
            content = habit.content
            category = habit.category
            done = habit.done
            timesAWeek = habit.timesAWeek
            
        }
        
    }


  }


