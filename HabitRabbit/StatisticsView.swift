//
//  StatisticsView.swift
//  HabitRabbit
//
//  Created by Julia Petersson  on 2023-05-01.
//

import SwiftUI

struct StatisticsView: View {
    
    @EnvironmentObject var habitList : HabitsVM
    @State var choosenDay = Date()
    @State var statisticView : String = "day"
    
    var body: some View {
        
        VStack{
            DatePicker("Show statistic for ", selection: $choosenDay, displayedComponents: [.date])
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

            }
        }
        List() {
                    ForEach(habitList.habits) { habit in
                        Section {
                            HStack {
                                StatisticsRowView(habit: habit, choosenDay: choosenDay, statisticView: statisticView)
                            }
                        }
                    }
                }
            }
        
    }

struct StatisticsRowView: View {
    let habit: Habit
    let choosenDay: Date
    var statisticView: String
    @EnvironmentObject var habitList: HabitsVM
    
    @State private var doneInMonth: [String] = []
    @State private var doneInWeek: [String] = []
    @State private var doneThatDay: Bool = false
    
    var body: some View {
        HStack {
            if statisticView == "month"{
            Text(habit.content)
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(doneInMonth, id: \.self) { date in
                        Text(date)
                    }}
            }
            else if  statisticView == "week"{
            Text(habit.content)
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(doneInWeek, id: \.self) { date in
                        Text(date)
                    }}
            }
            else {
           
                VStack(alignment: .leading, spacing: 8) {
                    if doneThatDay {
                        Text(habit.content)
                            .foregroundColor(.green)
                    }else
                    {Text(habit.content)
                            .foregroundColor(.red)
                    }
                    }
            }
        }
        .onAppear {
            doneInMonth = habitList.filterByMonth(habit: habit, choosenMonth: choosenDay)
            doneInWeek = habitList.filterByWeek(habit: habit, choosenWeek: choosenDay)
            doneThatDay = habitList.getDailyStatistic(choosenDay: choosenDay, habit: habit)
        }
        .onChange(of: choosenDay) { newDate in
            doneInMonth = habitList.filterByMonth(habit: habit, choosenMonth: newDate)
            doneInWeek = habitList.filterByWeek(habit: habit, choosenWeek: newDate)
            doneThatDay = habitList.getDailyStatistic(choosenDay: newDate, habit: habit)
        }
    }
}


//
//struct StatisticsRowView: View {
//    let habit: Habit
//    let choosenDay: Date
//    let statisticView: String
//    @EnvironmentObject var habitList: HabitsVM
//
//    @State private var donePerMonth = 0
//
//    var body: some View {
//        HStack {
//
//            Text(habit.content)
//        }
//        .onAppear {
//           // donePerMonth = habitList.getMonthlyStatitistcs(choosenMonth: choosenDay, habit: habit);
//            //habitList.fetchDateTracker(habit: habit)
//            habitList.filterByMonth(habit: habit, choosenMonth: choosenDay)
//        }
//    }
//}

//struct StatisticsView_Previews: PreviewProvider {
//
//
//    static var previews: some View {
//
//        StatisticsView()
//    }
//}
