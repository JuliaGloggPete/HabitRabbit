//
//  StatisticsView.swift
//  HabitRabbit
//
//  Created by Julia Petersson  on 2023-05-01.
//

import SwiftUI

struct StatisticsView: View {
    
    @EnvironmentObject var habitList : HabitsVM
    @State var today = Date()
    @State var statisticView : String = "day"
    
    var body: some View {
        
        //choose a date
        //datepicker
        //show deeds done that date
        VStack{
            DatePicker("Show statistic for ", selection: $today, displayedComponents: [.date])
                .padding()
                .foregroundColor(Color(red: 192/256, green:128/256,blue: 102/256))
            HStack{
                Button(action: {
                    statisticView = "day"
                }){
              
                    if statisticView == "day"{
                        Text("Show day")
                            .bold()
                    }
                    else
                    {Text("Show Day")}
                }
                    .foregroundColor(Color(red: 192/256, green:128/256,blue: 102/256))
                    .padding()
                
                Spacer()
                Button(action: {
                    statisticView = "week"
                }){
                    if statisticView == "week"{
                        Text("Show week")
                            .bold()
                    }
                    else
                    {Text("Show week")}
                    
                 
                    
                    
                }.foregroundColor(Color(red: 192/256, green:128/256,blue: 102/256))
                    .padding()
                Spacer()
                Button(action: {
                    statisticView = "month"
                }){
                    if statisticView == "month"{
                        Text("Show month")
                            .bold()
                    }
                    else
                    {Text("Show month")}
                    
              
                }.foregroundColor(Color(red: 192/256, green:128/256,blue: 102/256))
                    .padding()
            
                
               
                //https://www.youtube.com/watch?v=EnNAQ-b1yPU
            }
        }
        List() {
            
            
            // in vm måste jag ta in dagen - tar ner och sätta in en bool för dagen som efterfrågas som inte är habit.done utan done on a particular date
            
            ForEach(habitList.habits) { habit in
                
                Section{
                    
                    HStack{
                        StatisticsRowView(habit: habit)
                        
                        
                        
                        
                    }
                }
            }}
    }}
struct StatisticsRowView: View {
    let habit: Habit
    @EnvironmentObject var habitList: HabitsVM
    
    var body: some View {
        
            HStack{
                if habit.done{
                    Text("\(habit.content) was done")
                    .foregroundColor(.black)}
                else
             {
                    Text("\(habit.content) wasn't done")
                    .foregroundColor(.red)}
            }
    }
    }
struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
    }
}
