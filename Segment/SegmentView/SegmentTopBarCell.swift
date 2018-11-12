//
//  SectionTopBarCell.swift
//  SegmentVC
//
//  Created by 王涛 on 2018/10/8.
//  Copyright © 2018年 王涛. All rights reserved.
//

import UIKit
import SnapKit

class SegmentTopBarCell: UICollectionViewCell {
    
    private var _viewItem : SegmentItem?
    private var titleLabel : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initilization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initilization()
    }
    
    func initilization() {
        clipsToBounds = true
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        titleLabel = UILabel()
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
}

extension SegmentTopBarCell {
    //显示内容
    func willShow(viewItem: SegmentItem) {
        _viewItem = viewItem
        
        //展示内容
        titleLabel.text = viewItem.title
        if viewItem.isSelected {
            UIView.animate(withDuration: 0.25) {
                self.titleLabel.font = viewItem.style.selectedFont
                self.titleLabel.textColor = viewItem.style.selectedColor
            }
        } else {
            UIView.animate(withDuration: 0.25) {
                self.titleLabel.font = viewItem.style.normalFont
                self.titleLabel.textColor = viewItem.style.normalColor
            }
        }
    }
}
