//
//  NotificationsHandler.swift
//  MonstarHub
//
//  Created by Rokon on 5/4/20.
//  Copyright © 2020 Monstarlab. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationsHandler: NSObject {

    // MARK: Public methods

    func configure() {
        UNUserNotificationCenter.current().delegate = self
    }

    func registerForRemoteNotifications() {
        let application = UIApplication.shared
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) {_, _ in
            // do nothing for now
        }

        application.registerForRemoteNotifications()
    }

    func handleRemoteNotification(with userInfo: [AnyHashable: Any]) {
    }
}

extension NotificationsHandler: UNUserNotificationCenterDelegate {

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
}
