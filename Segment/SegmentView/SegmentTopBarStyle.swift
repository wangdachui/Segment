//
//  SegmentTopBarStyle.swift
//  puffer
//
//  Created by 王涛 on 2018/11/2.
//  Copyright © 2018年 sina. All rights reserved.
//

import UIKit

//风格控制
class SegmentTopBarStyle {
    
    var normalFont:UIFont = UIFont.systemFont(ofSize: 16)          //标签字体大小
    var selectedFont:UIFont = UIFont.systemFont(ofSize: 18)       //标签字体大小
    var selectedColor:UIColor = UIColor.black
    var normalColor:UIColor = UIColor.gray
    
    var showBottomLine:Bool = true        //是否显示底部的线
    var bottomLineColor:UIColor = .red
    var showExtraButton = true
    var extraBtnNormalImageName = ""
    var extraBtnSelectedImageName = ""
}

