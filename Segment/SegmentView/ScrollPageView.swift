//
//  ScrollPageView.swift
//  Segment
//
//  Created by 王涛 on 2018/11/9.
//  Copyright © 2018年 王涛. All rights reserved.
//

import UIKit

class ScrollPageView: UIView {
    typealias CustomViewController = ChildViewControllerProtocol & UIViewController
    var topBar : SegmentTopBarView!
    var pageViewController : UIPageViewController!
    var viewControllerDict: [String : CustomViewController]?
    weak var parentVC: UIViewController?
    var items: [SegmentItem] = []
    var currentIndex : Int = 0
    var isForbideScroll: Bool = true
    var customClassType: CustomViewController.Type
    var currentVC: UIViewController? {
        return fetchVC(index: currentIndex)
    }
    
    init(frame: CGRect, items: [SegmentItem], style: SegmentTopBarStyle, parentVC: UIViewController, customClassType: CustomViewController.Type) {
        self.customClassType = customClassType
        super.init(frame: frame)
        self.items = items
        self.parentVC = parentVC
        if let firstTag = items.first{
            let vc = customClassType.init(cid: firstTag.cid)
            viewControllerDict = [firstTag.cid : vc]
        }
        initUI(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI(style: SegmentTopBarStyle) {
        backgroundColor = UIColor.white
        guard let parentVC = parentVC else { return }
        // topBar
        let topBarFrame = CGRect(x: 0, y: C.Distance.statusBarHeightWithSafeArea, width: UIScreen.main.bounds.size.width, height: C.Distance.navBarHeight)
        topBar = SegmentTopBarView(frame: topBarFrame, style: style)
        topBar.delegate = self
        topBar.items = items
        addSubview(topBar)
        topBar.extraBtnOnClick = { (button) ->Void in
            //点击静音按钮
            button.isSelected = !button.isSelected
        }
        
        // pageController
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        pageViewController.view.frame = CGRect(x: 0, y: topBarFrame.maxY, width: bounds.width, height: bounds.height - topBarFrame.maxY)
        insertSubview(pageViewController.view, at: 0)
        
        parentVC.addChild(pageViewController)
        pageViewController.didMove(toParent: parentVC)
        
        for subview in pageViewController.view.subviews {
            if let scrollView = subview as? UIScrollView {
                scrollView.delegate = self
            }
        }
        if let firstTag = items.first,
            let firstVC = viewControllerDict?[firstTag.cid] {
            pageViewController.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func reload(items: [SegmentItem]) {
        topBar.items = items
        viewControllerDict?.removeAll()
        if let firstTag = items.first,
            let firstVC = viewControllerDict?[firstTag.cid] {
            pageViewController.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }

}

extension ScrollPageView {
    // 在此方法中定制自己的VC，并缓存在字典
    func fetchVC(index: Int) -> CustomViewController? {
        let tag = items[index]
        if let vc = viewControllerDict?[tag.cid] {
            // 数组有则取出返回
            return vc
        } else {
            // 数组无则创建并加入数组
            let vc = customClassType.init(cid: tag.cid)
            viewControllerDict?[tag.cid] = vc
            return vc
        }
    }
}

extension ScrollPageView: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? ChildViewControllerProtocol else {
            return nil
        }
        let viewControllerIndex = items.firstIndex { (tag) -> Bool in
            return tag.cid == currentVC.cid
        }
        
        if let currentIndex = viewControllerIndex {
            let viewControllersCount = items.count
            let nextIndex = currentIndex + 1
            guard viewControllersCount != nextIndex else {
                //循环播放
                if let firstTag = items.first {
                    return viewControllerDict?[firstTag.cid]
                }
                return nil
            }
            
            guard viewControllersCount > nextIndex else {
                return nil
            }
            return fetchVC(index: nextIndex)
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentFeedVC = viewController as? ChildViewControllerProtocol else {
            return nil
        }
        let viewControllerIndex = items.firstIndex { (tag) -> Bool in
            return tag.cid == currentFeedVC.cid
        }
        
        if let currentIndex = viewControllerIndex {
            let viewControllersCount = items.count
            let previousIndex = currentIndex - 1
            guard previousIndex >= 0 else {
                //循环播放
                if let lastTag = items.last {
                    return viewControllerDict?[lastTag.cid]
                }
                return nil
            }
            
            guard  viewControllersCount > previousIndex else {
                return nil
            }
            return fetchVC(index: previousIndex)
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if finished {
            if let currentVC = pageViewController.viewControllers?.first,
                let currentChildVC = currentVC as? ChildViewControllerProtocol {
                
                let index = items.firstIndex { (tag) -> Bool in
                    return tag.cid == currentChildVC.cid
                }
                if let index = index {
                    currentIndex = index
                    topBar.currentIndex = currentIndex
                }
            }
            
        }
    }
}

extension ScrollPageView: SegmentTopBarViewDelegate {
    
    func segmentTopBarView(segmentTopBarView: SegmentTopBarView, didSelectedIndex selectedIndex: Int) {
        isForbideScroll = true
        currentIndex = selectedIndex
        self.scrollToViewController(index: selectedIndex)
    }
    
    func scrollToViewController(index newIndex: Int) {
        if let currentVC = pageViewController?.viewControllers?.first,
            let currentChildVC = currentVC as? ChildViewControllerProtocol {
            // 获取当前tag下标
            let index = items.firstIndex { (tag) -> Bool in
                return tag.cid == currentChildVC.cid
            }
            
            if let index = index,
                let nextViewController = fetchVC(index: newIndex) {
                let direction: UIPageViewController.NavigationDirection = newIndex >= index ? .forward : .reverse
                pageViewController.setViewControllers([nextViewController],
                                                      direction: direction,
                                                      animated: true,
                                                      completion: nil)
            }
        }
    }
}

extension ScrollPageView: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbideScroll = false
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isForbideScroll { return}
        
        var progress:CGFloat = 0
        var nextIndex = 0
        let screenWidth = UIScreen.main.bounds.width
        let count = items.count
        
        //判断是左移还是右移
        if UIScreen.main.bounds.width > scrollView.contentOffset.x{    //右移动
            nextIndex = currentIndex - 1
            if nextIndex < 0 {
                nextIndex = 0
            }
            //计算progress
            progress = (screenWidth - scrollView.contentOffset.x)/screenWidth
        }
        if UIScreen.main.bounds.width < scrollView.contentOffset.x{    //左移
            nextIndex = currentIndex + 1
            if nextIndex > count - 1 {
                nextIndex = count - 1
            }
            progress = (scrollView.contentOffset.x - screenWidth)/screenWidth
        }
        if progress != 0.0 {
            topBar.pageViewScroll(nextIndex: nextIndex, progress: progress)
        }
    }
}

