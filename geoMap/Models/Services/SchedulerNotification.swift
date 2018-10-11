//
//  SchedulerNotification.swift
//  geoMap
//
//  Created by Olga Martyanova on 08/10/2018.
//  Copyright © 2018 olgamart. All rights reserved.
//

import Foundation
import UserNotifications

class SchedulerNotification {
    func makeNotificatioContent(title: String = "",
                                subtitle: String = "",
                                body: String = "",
                                badge: NSNumber = 0) -> UNNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.badge = badge
        return content
    }
    
    func makeIntervalNotificationTrigger(timeIntervalsecons: TimeInterval = 0,
                                         repeats: Bool = false) -> UNNotificationTrigger {
        return UNTimeIntervalNotificationTrigger (timeInterval: timeIntervalsecons, repeats: repeats)
    }
    
    func sendNotificationRequest (content: UNNotificationContent, trigger: UNNotificationTrigger, identifier: String) {
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content,
                                            trigger: trigger)
        let cener = UNUserNotificationCenter.current()
        cener.add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }        
    }
}
