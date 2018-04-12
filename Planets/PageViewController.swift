//
//  PageViewController.swift
//  Planets
//
//  Created by Qiana Barton on 11/22/17.
//  Copyright © 2017 Qiana Barton. All rights reserved.
//

import UIKit

class PageViewController:  UIPageViewController  {

    var pageDelegate: PageViewControllerDelegate?
    var page = 0

    
    override func viewDidAppear(_ animated: Bool) {

        
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        delegate = self
        dataSource = self
        
        //let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        


        setViewControllers([getWelcomeOne()],
                               direction: .forward,
                               animated: true,
                               completion: nil)
    
        pageDelegate?.pageViewController(pageViewController: self, didUpdatePageCount: 2)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getWelcomeOne() -> WelcomeOneViewController {
        page = 0
        return storyboard!.instantiateViewController(withIdentifier: "WelcomeOne") as! WelcomeOneViewController
    }
    
    func getWelcomeTwo() -> WelcomeTwoViewController {
        page = 1
        return storyboard!.instantiateViewController(withIdentifier: "WelcomeTwo") as! WelcomeTwoViewController
    }
    
    

    
}
    


extension PageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if viewController.isKind(of: WelcomeOneViewController.self) {
            // 0 -> 1
            return getWelcomeTwo()
        } else {
            // 1 -> end of the road
            return nil
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController.isKind(of: WelcomeTwoViewController.self) {
            // 1 -> 0
            return getWelcomeOne()
        } else {
            // 0 -> end of the road
            return nil
        }
    }
    

}
    
extension PageViewController: UIPageViewControllerDelegate {
        
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        pageDelegate?.pageViewController(pageViewController: self, didUpdatePageIndex: self.page)
        
    }
}
    
protocol PageViewControllerDelegate: class {
    func pageViewController(pageViewController: PageViewController,didUpdatePageCount count: Int)
    
    func pageViewController(pageViewController: PageViewController, didUpdatePageIndex index: Int)
}


