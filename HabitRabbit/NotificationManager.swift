//
//  NotificationManager.swift
//  HabitRabbit
//
//  Created by Julia Petersson  on 2023-04-28.
//

import Foundation
import UserNotifications


final class NotificationManager: ObservableObject {
    @Published private(set) var notifications: [UNNotificationRequest] = []
    @Published private(set) var authorizationStatus: UNAuthorizationStatus?
    
    func reloadAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings{ settings in
            DispatchQueue.main.async {
                self.authorizationStatus = settings.authorizationStatus
            }
           //wt
            
            
        }
    }
    func requestAuthorization(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {
            isGranted, _ in
            
            DispatchQueue.main.async {
                self.authorizationStatus = isGranted ? . authorized : .denied
            }
        }
        
        
    }
    
    func reloadLocalNotificaitons(){
        
        UNUserNotificationCenter.current().getPendingNotificationRequests{ notificaitons in
            DispatchQueue.main.async {
                self.notifications = notificaitons
            }
            
        }
        }
    func createLocalNotification(title: String, hour: Int, minute: Int, completion: @escaping (Error?) -> Void){
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
       // dateComponents.weekday om man vill bygga ut
        
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.sound = .default
        
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: completion)
        
        
    }
     
    
    }
    

