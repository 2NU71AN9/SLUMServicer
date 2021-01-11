//
//  AppDelegate.swift
//  SLUMHandler
//
//  Created by 孙梁 on 2020/8/11.
//  Copyright © 2020 孙梁. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WXApiDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        MobSDK.uploadPrivacyPermissionStatus(true, onResult: nil)
        WXApi.registerApp("wxac7f360237a214cc", universalLink: "https://bo5k.t4m.cn/myCommProject/")

        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        WXApi.handleOpen(url, delegate: self)
        return true
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        WXApi.handleOpenUniversalLink(userActivity, delegate: self)
        return true
    }
}
