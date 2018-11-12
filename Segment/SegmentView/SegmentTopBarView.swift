//
//  SectionTopBarView.swift
//  SegmentVC
//
//  Created by 王涛 on 2018/10/8.
//  Copyright © 2018年 王涛. All rights reserved.
//

import UIKit

protocol SegmentTopBarViewDelegate : class {
    func segmentTopBarView(segmentTopBarView: SegmentTopBarView, didSelectedIndex selectedIndex: Int)
}

class SegmentTopBarView: UIView {
    
    var items: [SegmentItem]? {
        didSet {
            items?.forEach({ [weak self] (item) in
                guard let _s = self else {
                    return
                }
                item.style = _s.style
            })
            refreshUI()
        }
    }
    
    var style: SegmentTopBarStyle = SegmentTopBarStyle()
    
    /// 附加按钮点击响应(click extraBtn)
    var extraBtnOnClick: ((_ extraBtn: UIButton) -> Void)?
    lazy var extraBtn:UIButton = {
        let image = UIImage(named: "feed_volume_off")
        let selectedImage = UIImage(named: "feed_volume_on")
        let w = (image?.size.width ?? 0) + 2*15
        let btn = UIButton(frame: CGRect(x: bounds.size.width - w, y: 0, width: w, height: bounds.size.height))
        btn.setImage(image, for: .normal)
        btn.setImage(selectedImage, for: .selected)
        btn.backgroundColor = UIColor.white
        // 设置边缘的阴影效果
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOffset = CGSize(width: -5, height: 0)
        btn.layer.shadowOpacity = 0.1
        btn.clipsToBounds = false

        btn.addTarget(self, action: #selector(self.didLClickOnExtraButton(_:)), for: .touchUpInside)
        return btn
    }()

    
    lazy var lineView:UIView = {
        let line = UIView()
        let color = style.bottomLineColor
        line.backgroundColor = color
        line.frame.size.height = 3
        line.layer.cornerRadius = line.bounds.width/2
        line.frame.origin.y = bounds.size.height - line.frame.size.height - 5
        
        line.layer.shadowColor = color.cgColor
        line.layer.shadowOpacity = 0.5//不透明度
        line.layer.shadowRadius = 5.0//设置阴影所照射的范围
        line.layer.shadowOffset = CGSize.init(width: 0, height: 0)// 设置阴影的偏移量
        return line
    }()
    
    var currentIndex: Int = 0 {
        didSet {
            if let curItem = items?[currentIndex] {
                items?.forEach { (item) in
                    if curItem.title == item.title {
                        item.isSelected = true
                    } else {
                        item.isSelected = false
                    }
                }
                
                lineView.frame.size.width = curItem.titleSize.width
                if let currentCell = collectionView.cellForItem(at: IndexPath(row: currentIndex, section: 0)) {
                    lineView.center.x = currentCell.convert(CGPoint(x: currentCell.bounds.width / 2.0, y: 0), to: collectionView).x
                }
                
                collectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
                delegate?.segmentTopBarView(segmentTopBarView: self, didSelectedIndex: currentIndex)
            }
            collectionView.reloadData()
        }
    }
    
    weak var delegate: SegmentTopBarViewDelegate?
    
    fileprivate var collectionView : UICollectionView!
    
    init(frame: CGRect, style: SegmentTopBarStyle) {
        self.style = style
        super.init(frame: frame)
        initUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI() {
        clipsToBounds = true
        //collectionView
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.footerReferenceSize = CGSize(width: 0, height: 30)
        layout.headerReferenceSize = CGSize(width: 0, height: 30)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.register(SegmentTopBarCell.self, forCellWithReuseIdentifier: "SegmentTopBarCell")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsHorizontalScrollIndicator = false
        
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.leading.bottom.equalToSuperview()
            if !style.showExtraButton {
                make.trailing.equalToSuperview()
            }
        }
        if style.showExtraButton {
            //extraButton
            addSubview(extraBtn)
            extraBtn.snp.makeConstraints { (make) in
                make.width.equalTo(extraBtn.bounds.width)
                make.top.trailing.bottom.equalToSuperview()
                make.leading.equalTo(collectionView.snp.trailing)
            }
        }
        
        if style.showBottomLine {
            //lineView
            collectionView.addSubview(lineView)
        }
        
    }
    
    func refreshUI() {
        if let item = items?.first {
            lineView.width = item.titleSize.width
            lineView.center.x = item.viewSize.width/2
        }
        collectionView.reloadData()
    }
    
    func pageViewScroll(nextIndex: Int, progress: CGFloat) {
        
        if let currentCell = collectionView.cellForItem(at: IndexPath(row: currentIndex, section: 0)),
            let nextCell = collectionView.cellForItem(at: IndexPath(row: nextIndex, section: 0)),
            let currentItem = items?[currentIndex],
            let nextItem = items?[nextIndex] {
            //设置lineView中心的渐变
            var deltaX:CGFloat = 0
            deltaX = nextCell.center.x - currentCell.center.x
            lineView.center.x = currentCell.center.x + deltaX*progress
            //2.宽度的变化
            var deltaW:CGFloat = 0
            deltaW = nextItem.titleSize.width - currentItem.titleSize.width
            lineView.frame.size.width = currentItem.titleSize.width + deltaW*progress
        }
    }
    
    @objc func didLClickOnExtraButton(_ button:UIButton) {
        extraBtnOnClick?(button)
    }
}

extension SegmentTopBarView : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = items?[indexPath.row], let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SegmentTopBarCell", for: indexPath) as? SegmentTopBarCell else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
        }
        cell.willShow(viewItem: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let item = items?[indexPath.row] else {
            return CGSize.zero
        }
        return item.viewSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        currentIndex = indexPath.row
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let currentCell = collectionView.cellForItem(at: IndexPath(row: currentIndex, section: 0)) {
            lineView.center.x = currentCell.convert(CGPoint(x: currentCell.bounds.width / 2.0, y: 0), to: scrollView).x
        }
    }
}
