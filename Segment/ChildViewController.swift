//
//  ChildViewController.swift
//  Segment
//
//  Created by 王涛 on 2018/11/9.
//  Copyright © 2018年 王涛. All rights reserved.
//

import UIKit

protocol ChildViewControllerProtocol: class {
    
    var cid: String { set get }
    
    init(cid: String)
}

// 自定义对象，必须实现ChildViewControllerProtocol协议
class ChildViewController: UIViewController, ChildViewControllerProtocol {

    var cid: String
    
    required init(cid: String) {
        self.cid = cid
        super.init(nibName: nil, bundle: nil)
        
        let r = CGFloat(arc4random()%255)/255
        let g = CGFloat(arc4random()%255)/255
        let b = CGFloat(arc4random()%255)/255
        
        let color = UIColor(displayP3Red: r, green: g, blue: b, alpha: 1)
        view.backgroundColor = color
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
