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

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        MobSDK.uploadPrivacyPermissionStatus(true, onResult: nil)
        
        _ = SLUMServicer.shared.regist("5fd97b5f498d9e0d4d90761a")
            .registAnalytics()
            .registShare(wechatAppId: "wxac7f360237a214cc", wechatAppSecret: "08196524f27704095dbe7ece0d7dc304", universalLink: "https://bo5k.t4m.cn/myCommProject/")
            .registPush(launchOptions)
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        SLUMServicer.shared.registDeviceToken(deviceToken)
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        if SLUMServicer.shared.handleOpenURL(url: url, options: options) == false {
            // 其他SDK的回调
        }
        return true
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if SLUMServicer.shared.handleUniversalLink(activity: userActivity) == false {
            // 其他SDK的回调
        }
        return true
    }
}
