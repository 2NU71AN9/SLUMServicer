//
//  ViewController.swift
//  SLUMHandler
//
//  Created by 孙梁 on 2020/8/11.
//  Copyright © 2020 孙梁. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            SLUMServicer.shared.shareText("这是友盟分享内容") { (isSuccess) in
                print("分享结果==>\(isSuccess)")
            }
        case 1:
            SLUMServicer.shared.shareImage("https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1091405991,859863778&fm=26&gp=0.jpg") { (isSuccess) in
                print("分享结果==>\(isSuccess)")
            }
        case 2:
            SLUMServicer.shared.shareUrl("www.baidu.com", title: "这是链接", text: "这是内容这是内容这是内容这是内容这是内容这是内容", image: UIImage(named: "wechatTimeLine50")) { (isSuccess) in
                print("分享结果==>\(isSuccess)")
            }
        case 3:
            SLUMServicer.shared.shareVideo("http://v.youku.com/v_show/id_XOTQwMDE1ODAw.html?from=s1.8-1-1.2&spm=a2h0k.8191407.0.0", title: "这是视频", text: "这是内容这是内容这是内容这是内容这是内容这是内容", image: UIImage(named: "wechatTimeLine50")) { (isSuccess) in
                print("分享结果==>\(isSuccess)")
            }
        case 4:
            SLUMServicer.shared.shareAudio("http://c.y.qq.com/v8/playsong.html?songid=108782194&source=yqq#wechat_redirect", title: "这是音频", text: "这是内容这是内容这是内容这是内容这是内容这是内容", image: UIImage(named: "wechatTimeLine50")) { (isSuccess) in
                print("分享结果==>\(isSuccess)")
            }
        case 5:
            SLUMServicer.shared.shareMiniApp(title: "这是小程序", text: "小程序描述", url: "www.jiguang.cn", userName: "gh_d43f693ca31f", path: "pages/page", type: .release, image: UIImage(named: "wechatTimeLine50")) { (isSuccess) in
                print("分享结果==>\(isSuccess)")
            }
        default:
            break
        }
    }
}
