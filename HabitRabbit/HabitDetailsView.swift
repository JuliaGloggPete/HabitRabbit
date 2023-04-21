//
//  HabitDetailsView.swift
//  HabitRabbit
//
//  Created by Julia Petersson  on 2023-04-19.
//

import SwiftUI

struct HabitDetailsView: View {
    var habit : Habit?
    @ObservedObject var habits : HabitsVM
    
    @State var content : String = ""
    @State var category : String = "Category"
    @State var timesAweek : Int = 7
    
    var body: some View {
        
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
                    Button(action: {timesAweek = number}, label: {
                        Text("\(number)")
                        
                    })
                }
                
            } label: {
                Label(title: { Text("\(timesAweek) Times a week") }, icon: { Image(systemName: "figure.run") })
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
    let newHabit = Habit(content: content, done: false, category: category, timesAweek: timesAweek)

     habits.habits.append(newHabit)
    }

  

  }

/*struct HabitDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        HabitDetailsView()
    }
}*/
