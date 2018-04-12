//
//  AboutViewController.swift
//  Planets
//
//  Created by Qiana Barton on 2/24/18.
//  Copyright © 2018 Qiana Barton. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func closeButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeAbout (_ sender: UIButton) {
                self.dismiss(animated: true, completion: nil)
    }
   
    @IBAction func PortfolioLink(_ sender: UIButton) {
        
        if let url = NSURL(string: "https://qianabarton.github.io/") {
            UIApplication.shared.open(url as URL, options: [:])
        }
    }
    
    
    @IBAction func SourceCodeLink(_ sender: UIButton) {
        if let url = NSURL(string: "https://github.com/qianabarton/Planets-iOS") {
            UIApplication.shared.open(url as URL, options: [:])
        }
        
    }
    
    
    
}
