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
    //@ObservedObject var habits : HabitsVM
    @EnvironmentObject var habitList : HabitsVM
    @State var content : String = ""
    @State var category : String = "Category"
    @State var timesAWeek : Int = 7
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        
        //current problems - times a week, category blirinte medskickat... ska kolla på det
        
        VStack{
              TextField("Name of habit: ", text: $content)
                    .font(.title2)
                    .onChange(of: content) { newValue in
                        if content.count > 60 {
                            content = String(content.prefix(60))
                        }
                    }
            
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
            
        }
        .onAppear(perform: setContent)
        .navigationBarItems(trailing: Button("Save"){
            saveNewHabit()
            presentationMode.wrappedValue.dismiss()
            
        })
    }
    
    private func setContent() {
        
        if let habit = habit {
            content = habit.content
        }
        
    }
    
    private func saveNewHabit() {
        
        
        
        if category == "Category" {
            category = "Other"
        }
        
        if let habit = habit{
            
            habitList.update(habit: habit, with: content, with: category, with: timesAWeek)
            
            
        } else{
            let newHabit = Habit(content: content, done: false, category: category, timesAWeek: timesAWeek)
            do {
                try db.collection("NewHabit").addDocument(from: newHabit)
                //    habitList.habits.append(newHabit)
            } catch {
                print("Errorroro")
            }
            
        }
        
    }

  }

/*func saveNewtoFSHabit(habitDescription: String){
    let habit = Habit(content: habitDescription, done: false, category: "Health sport", timesAWeek: 4)
    do {
        
        
        try db.collection("test2").addDocument(from: habit)
    }catch{
        print("Error")
    }
    
}

struct HabitDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        HabitDetailsView()
    }
}*/
