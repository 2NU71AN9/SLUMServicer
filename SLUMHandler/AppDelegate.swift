//
//  AppDelegate.swift
//  SLUMHandler
//
//  Created by 孙梁 on 2020/8/11.
//  Copyright © 2020 孙梁. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UMManager.shared.registAll("", wechatAppKey: "", wechatAppSecret: "", wechatRedirectURL: "", launchOptions: launchOptions)
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        UMManager.shared.registDeviceToken(deviceToken)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if UMManager.shared.handleOpenURL(url: url, options: options) == false {
            // 其他SDK的回调
        }
        return true
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if UMManager.shared.handleUniversalLink(activity: userActivity) == false {
            // 其他SDK的回调
        }
        return true
    }
}

