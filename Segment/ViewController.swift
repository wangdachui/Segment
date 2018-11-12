//
//  ViewController.swift
//  Segment
//
//  Created by 王涛 on 2018/11/9.
//  Copyright © 2018年 王涛. All rights reserved.
//

import UIKit

/**
 概述：
 封装新闻类App顶部标签，再加上对VC的控制。
 标签SegmentTopBarView使用collectionView。VC控制用PageViewController，VC创建懒加载，需要展示的时候创建并缓存。所以原则上讲可以无限扩展，内存管理效率极佳
 
 使用：
 1 风格控制类SegmentTopBarStyle
 2 数据源[SegmentItem]
 3 自定义VC必须实现ChildViewControllerProtocol协议，协议中初始化方法可以按需修改，增加参数
 4 SegmentTopBarView和ScrollPageView是独立的，所以你也可以单独使用其中某一个控件
 **/
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //风格控制
        let style = SegmentTopBarStyle()
        style.bottomLineColor = UIColor.red
        style.showExtraButton = false
        
        //datasource
        let items = dataSource()
        
        //ScrollPageView
        let subiView = ScrollPageView(frame: view.bounds,
                                      items: items,
                                      style: style,
                                      parentVC: self,
                                      customClassType: ChildViewController.self)
        view.addSubview(subiView)
    }

    func dataSource() -> [SegmentItem] {
        var arr = [SegmentItem]()
        for i in 0...10 {
            let item = SegmentItem(title: "title\(i)", cid: "\(i)")
            arr.append(item)
        }
        return arr
    }

}

