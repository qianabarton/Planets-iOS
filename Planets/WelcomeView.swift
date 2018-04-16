//
//  PassThroughView.swift
//  Planets
//
//  Created by Qiana Barton on 4/15/18.
//  Copyright © 2018 Qiana Barton. All rights reserved.
//

import UIKit

class WelcomeView: UIView {

    // makes it so you can click on the game view controller but also access the get started button in this view
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
            for subview in subviews {
                if !subview.isHidden && subview.isUserInteractionEnabled && subview.point(inside: convert(point, to: subview), with: event) {
                    return true
                }
            }
            return false
        }
 
}
