//
//  ContentView.swift
//  HabitRabbit
//
//  Created by Julia Petersson  on 2023-04-18.
//

import SwiftUI
import Firebase

struct ContentView : View {
    
    @EnvironmentObject var habitList : HabitsVM
    @State var signedIn = false
    
    var body: some View {
        
        if !signedIn {
            SignInView()
            
        }else {
            HabitDetailsView()
        }
        
    }
    
}


struct SignInView : View {
    @EnvironmentObject var habitList : HabitsVM
    
    var body: some View {
        
        Text("Hej")
        
    }
    
    
}


struct ContentView: View {


    @EnvironmentObject var habitList : HabitsVM
    
    var body: some View {
        NavigationView{
            VStack {
                
                
                
                //List under list för eventuellt subclass om done som heter dagens dag och false or true o sen dagens datum
                // minus -1 osv för att visa progressen
                
                List() {
                    ForEach(habitList.habits) { habit in
                        NavigationLink(destination: HabitDetailsView(habit: habit)) {
                            HabitsRowView(habit: habit)}
                    }
                }
             
                
            }
            .navigationTitle("Habit")
            .navigationBarItems(trailing: NavigationLink(destination: HabitDetailsView()){
                Image(systemName: "plus.circle")
            })
            .onAppear(){
                habitList.listen2FS()
      
                
            }
          
        }
        
        
        
    }
    

}
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }



struct HabitsRowView: View {
    let habit : Habit
    @EnvironmentObject var habitList : HabitsVM
    var body: some View {
        HStack{
            /*@START_MENU_TOKEN@*/Text(habit.content)/*@END_MENU_TOKEN@*/
                .foregroundColor(habit.category == "Nutrition/Health" ? .blue : habit.category == "Nutrition/Health" ? .green : .black)
                .listRowBackground(habit.category == "Health sport" ? Color.yellow : habit.category == "Health nutrition" ? Color.blue : Color.white)
          
            Spacer()
            // Text(" times \(habit.timesAWeek)")
            //    Spacer()
            Button(action: {
                habitList.toggle(habit: habit)
                
            }) {
                Image(systemName: habit.done ?  "checkmark.seal.fill" : "seal" )
                .foregroundColor(.cyan)}
        }
    }
}
