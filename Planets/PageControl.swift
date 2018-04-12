//
//  PageControl.swift
//  Planets
//
//  Created by Qiana Barton on 4/12/18.
//  Copyright © 2018 Qiana Barton. All rights reserved.
//

import UIKit

class PageControl: UIViewController {
    
    var launch = ""
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.isHidden = true
    }
    override func viewWillLayoutSubviews() {
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")

        //let firstLaunch = FirstLaunch(userDefaults: .standard, key: "com.any-suggestion.FirstLaunch.WasLaunchedBefore")
        if launchedBefore {
            // move on to planets view
            performSegue(withIdentifier: "navigationSegue", sender: self)

        } else {
            // show the instructions
            self.view.isHidden = false
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dots.transform = CGAffineTransform(scaleX: 2, y: 2)
        
        dots.subviews.forEach {
            $0.transform = CGAffineTransform(scaleX: 2, y: 2)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBOutlet weak var dots: UIPageControl!
    
    @IBAction func clickedGetStarted(_ sender: UIButton) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let PageViewController = segue.destination as? PageViewController {
            PageViewController.pageDelegate = self
        }
    }
    
}

extension PageControl: PageViewControllerDelegate {
    func pageViewController(pageViewController: PageViewController, didUpdatePageCount count: Int) {
        dots.numberOfPages = count

    }
    
    func pageViewController(pageViewController: PageViewController, didUpdatePageIndex index: Int) {
        dots.currentPage = index
    }
    
    
}


