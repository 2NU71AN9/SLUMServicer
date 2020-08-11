//
//  UMManager.swift
//  SLUMHandler
//
//  Created by 孙梁 on 2020/8/11.
//  Copyright © 2020 孙梁. All rights reserved.
//

import UIKit
import SLSupportLibrary
import PKHUD

class UMManager: NSObject {
    @objc static let shared = UMManager()
    private override init() { super.init() }
    
    /// 注册友盟key
    @objc func regist(_ appKey: String) {
        UMConfigure.initWithAppkey(appKey, channel: "App Store")
    }
    
    /// 注册友盟
    /// - Parameters:
    ///   - appKey: 友盟key
    ///   - wechatAppKey: 微信AppKey
    ///   - wechatAppSecret: 微信AppSecret
    ///   - wechatRedirectURL: 微信RedirectURL
    ///   - launchOptions: launchOptions
    @objc func registAll(_ appKey: String, wechatAppKey: String, wechatAppSecret: String, wechatRedirectURL: String, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        regist(appKey)
        setPush(launchOptions)
        setShare(wechatAppKey, appSecret: wechatAppSecret, redirectURL: wechatRedirectURL)
        setAnalytics()
    }
    
    /// 推送
    @objc func setPush(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        #if DEBUG
        UMConfigure.setLogEnabled(true)
        #else
        UMConfigure.setLogEnabled(false)
        #endif
        print("deviceID==>\(UMConfigure.deviceIDForIntegration() ?? "")")
        
        let entity = UMessageRegisterEntity()
        entity.types = Int(UMessageAuthorizationOptions.badge.rawValue | UMessageAuthorizationOptions.sound.rawValue | UMessageAuthorizationOptions.alert.rawValue)
        UNUserNotificationCenter.current().delegate = self
        UMessage.registerForRemoteNotifications(launchOptions: launchOptions, entity: entity) { (granted, error) in
            print(granted)
        }
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in }
    }
    
    /// 分享
    /// - Parameters:
    ///   - wechatAppKey: 微信appKey
    ///   - appSecret: 微信appSecret
    ///   - redirectURL: 微信redirectURL
    @objc func setShare(_ wechatAppKey: String, appSecret: String, redirectURL: String) {
        #if DEBUG
        UMConfigure.setLogEnabled(true)
        #else
        UMConfigure.setLogEnabled(false)
        #endif
        print("deviceID==>\(UMConfigure.deviceIDForIntegration() ?? "")")

        UMSocialGlobal.shareInstance()?.isUsingWaterMark = true
        UMSocialGlobal.shareInstance()?.isUsingHttpsWhenShareContent = false
        UMSocialGlobal.shareInstance()?.universalLinkDic = [UMSocialPlatformType.wechatSession: "https://cs.znclass.com"]
        
        UMSocialManager.default()?.setPlaform(.wechatSession, appKey: wechatAppKey, appSecret: appSecret, redirectURL: redirectURL)
        /*设置小程序回调app的回调*/
        UMSocialManager.default()?.setLauchFrom(.wechatSession, completion: { (userInfoResponse, error) in
            print("setLauchFromPlatform:userInfoResponse:\(String(describing: userInfoResponse))")
        })
        UMSocialManager.default()?.removePlatformProvider(with: .wechatFavorite)
        UMSocialShareUIConfig.shareInstance()?.shareCancelControlConfig.shareCancelControlText = ""
        UMSocialShareUIConfig.shareInstance()?.shareCancelControlConfig.shareCancelControlBackgroundColor = .clear
    }
    
    /// 统计
    @objc func setAnalytics() {
        #if DEBUG
        UMConfigure.setLogEnabled(true)
        #else
        UMConfigure.setLogEnabled(false)
        #endif
        print("deviceID==>\(UMConfigure.deviceIDForIntegration() ?? "")")
        UMCommonLogManager.setUp()
        MobClick.setAutoPageEnabled(true)
    }
}

// MARK: - 推送
extension UMManager {
    @objc func registDeviceToken(_ deviceToken: Data?) {
    //        let devieTokenString = deviceToken?.reduce("", { $0 + String(format: "%02x", $1) })
        UMessage.registerDeviceToken(deviceToken)
    }
    
    @objc func handleOpenURL(url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        return UMSocialManager.default()?.handleOpen(url, options: options) ?? false
    }
    
    @objc func handleUniversalLink(activity: NSUserActivity) -> Bool {
        return UMSocialManager.default()?.handleUniversalLink(activity, options: nil) ?? false
    }
    
    @objc func addTags(_ tag: [String]) {
        UMessage.addTags(tag) { (responseObject, remain, error) in
            if let error = error { print(error) }
        }
    }
    @objc func deleteTags(_ tag: [String]) {
        UMessage.deleteTags(tag) { (responseObject, remain, error) in
            if let error = error { print(error) }
        }
    }
    
    /// 添加别名
    @objc func addAlias(_ name: String, type: String) {
        UMessage.addAlias(name, type: type) { (responseObject, error) in
            if let error = error { print(error) }
        }
    }
    /// 重置别名
    @objc func setAlias(_ name: String, type: String) {
        UMessage.setAlias(name, type: type) { (responseObject, error) in
            if let error = error { print(error) }
        }
    }
    /// 移除别名
    @objc func removeAlias(_ name: String, type: String) {
        UMessage.removeAlias(name, type: type) { (responseObject, error) in
            if let error = error { print(error) }
        }
    }
}

extension UMManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        if notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self) ?? false {
            //应用处于前台时的远程推送接受
            UMessage.setAutoAlert(false)
            UMessage.didReceiveRemoteNotification(userInfo)
        } else {
            //应用处于前台时的本地推送接受
        }
        completionHandler(.badge)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self) ?? false {
            //应用处于后台时的远程推送接受
            UMessage.didReceiveRemoteNotification(userInfo)
        } else {
            //应用处于后台时的本地推送接受
        }
    }
}

// MARK: - 分享
extension UMManager {
    @objc func shareText(_ text: String, success: (() -> Void)?, failure: (() -> Void)?) {
        UMSocialUIManager.showShareMenuViewInWindow { (platform, value) in
            let messageObject = UMSocialMessageObject()
            let shareMessage = UMShareObject.shareObject(withTitle: text, descr: nil, thumImage: nil)
            messageObject.shareObject = shareMessage
            UMSocialManager.default()?.share(to: platform, messageObject: messageObject, currentViewController: cur_visible_vc) { (data, error) in
                if error == nil {
                    HUD.flash(.label("分享成功"), delay: 1.5, completion: nil)
                    success?()
                } else {
                    HUD.flash(.label("分享失败"), delay: 1.5, completion: nil)
                    failure?()
                }
            }
        }
    }
    
    @objc func shareMiniApp(success: (() -> Void)?, failure: (() -> Void)?) {
        let messageObject = UMSocialMessageObject()
        let shareMessage = UMShareMiniProgramObject.shareObject(withTitle: "", descr: "", thumImage: nil) as? UMShareMiniProgramObject
        // FIXME: -
        shareMessage?.webpageUrl = ""
        shareMessage?.userName = ""
        shareMessage?.path = ""
        shareMessage?.miniProgramType = .release
        messageObject.shareObject = shareMessage
        UMSocialManager.default()?.share(to: .wechatSession, messageObject: messageObject, currentViewController: cur_visible_vc) { (data, error) in
            if error == nil {
                HUD.flash(.label("分享成功"), delay: 1.5, completion: nil)
                success?()
            } else {
                HUD.flash(.label("分享失败"), delay: 1.5, completion: nil)
                failure?()
            }
        }
    }
}

// MARK: - 统计
extension UMManager {
    @objc func setEvent(_ event: CustomEvent, parameters: [String: Any]?) {
        if let parameters = parameters {
            MobClick.event(event.name, attributes: parameters)
        } else {
            MobClick.event(event.name)
        }
    }
    
    @objc func setEvent(_ event: CustomEvent, parameters: [String: Any]?, counter: Int) {
        MobClick.event(event.name, attributes: parameters, counter: Int32(counter))
    }
}
