//
//  ViewController.swift
//  SLUMHandler
//
//  Created by 孙梁 on 2020/8/11.
//  Copyright © 2020 孙梁. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        let req = SendMessageToWXReq()
        req.bText = true
        req.text = "分享的内容"
        req.scene = Int32(WXSceneSession.rawValue)
        WXApi.send(req) { (isSuccess) in
            print("分享结果==>\(isSuccess)")
        }
    }
}
