//
//  CarouselPageViewController.swift
//  CarouselSample
//
//  Created by AMRUTHAPRASAD KK on 05/05/21.
//  Copyright © 2021 MB. All rights reserved.
//
import Foundation
import UIKit

class CarouselPageViewController: UIPageViewController {
    var caroselDelegate : CarouselViewControllerProtocol?
    fileprivate var items: [UIViewController] = []
    fileprivate var brands: [Brand]?
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        setupInitialView()
        
        fetchItems()
        if let firstViewController = items.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    fileprivate func setupInitialView() {
        let pc = UIPageControl.appearance(whenContainedInInstancesOf: [CarouselPageViewController.self])
        pc.currentPageIndicatorTintColor = .orange
        pc.pageIndicatorTintColor = .gray
    }
    
    fileprivate func fetchItems() {
        let viewModel = WebServiceViewModel()
        brands = viewModel.fetchData()
        caroselDelegate?.updateList(with: brands?.first?.models ?? [])
        for (_, t) in brands!.enumerated() {
            let c = createCarouselItemControler(with: t.brand, with: t.url, and: t.models)
            items.append(c)
        }
    }
    
   
    fileprivate func createCarouselItemControler(with name: String?, with url: String?, and models: [String]?) -> UIViewController {
        let c = UIViewController()
        c.view = CarouselItem(name: name, url: url, models: models ?? [])
        return c
    }
}

// MARK: - DataSource
extension CarouselPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let currentView = pageViewController.viewControllers![0].view as? CarouselItem {
                caroselDelegate?.updateList(with: currentView.models ?? [])
            }
        }
    }
}
extension CarouselPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = items.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return items.last
        }
        
        guard items.count > previousIndex else {
            return nil
        }
        
        return items[previousIndex]
    }
    
    func pageViewController(_: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = items.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        guard items.count != nextIndex else {
            return items.first
        }
        
        guard items.count > nextIndex else {
            return nil
        }
        
        return items[nextIndex]
    }
    
    func presentationCount(for _: UIPageViewController) -> Int {
        return items.count
    }
    
    func presentationIndex(for _: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = items.index(of: firstViewController) else {
                return 0
        }
        
        return firstViewControllerIndex
    }
}
