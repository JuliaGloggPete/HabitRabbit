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
    @EnvironmentObject var habitList : HabitsVM
    @State var content : String = ""
    @State var category : String = "Category"
    @State var done : Bool = false
    @State var timesAWeek : Int = 7
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
                
                Spacer()
                
                
                Menu{
                    Button(action: {content = "Go for a 30min walk"; category = "Sports/Health"; timesAWeek = 7
                    }, label: {
                        Text("Go for a 30min walk")
                        
                    })
                    
                    
                }label: {
                    Label(title: {Text("Suggestions")},
                          
                          icon:{Image(systemName: "hare")}
                    )
                }
                
        }
        .onAppear(perform: setContent)
        .navigationBarTitle("Habit Detail", displayMode: .inline)
        .navigationBarItems(trailing: Button("Save"){
            if let habit = habit{
                habitList.saveHabit(habit:habit)}
            else
            {
                
                let date = Date()
                let newHabit = Habit(content: content, done: false, category: category, timesAWeek: timesAWeek, dateTracker: [],currentStreak: 0,initialDate: date)
                habitList.saveHabit(habit: newHabit)

                
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


