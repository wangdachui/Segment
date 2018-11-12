//
//  SectionItem.swift
//  SegmentVC
//
//  Created by 王涛 on 2018/10/8.
//  Copyright © 2018年 王涛. All rights reserved.
//

import UIKit

class SegmentItem {
    var style: SegmentTopBarStyle!
    var title : String
    var cid : String
    var titleSize : CGSize {
        return title.size(withConstraintedSize: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), font: self.style.selectedFont)
    }
    var viewSize: CGSize {
        return CGSize(width: titleSize.width + 25, height: 30)
    }
    var isSelected : Bool = false
    
    init(title: String,cid: String) {
        self.title = title
        self.cid = cid
    }
}

extension String {
    public func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.size(withConstraintedSize: constraintSize, font: font)
        return ceil(boundingBox.height)
    }
    
    public func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintSize = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.size(withConstraintedSize: constraintSize, font: font)
        return ceil(boundingBox.width)
    }
    
    public func size(withConstraintedSize constraintSize: CGSize, font: UIFont) -> CGSize {
        let boundingBox = self.boundingRect(with: constraintSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.size
    }
}

