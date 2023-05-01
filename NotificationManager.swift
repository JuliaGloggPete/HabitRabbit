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
        
        
    }
    

