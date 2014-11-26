//
//  FNKBar.swift
//  FNKCharts
//
//  Created by Phillip Connaughton on 11/23/14.
//  Copyright (c) 2014 FitnessKeeper inc. All rights reserved.
//

import Foundation
import UIKit

class FNKBar: UIView {
    
    var adjustmentHeight: CGFloat = 5.0
    var originalFrame : CGRect?
    var data : FNKBarOverlayData
    
    init(data : FNKBarOverlayData, frame : CGRect)
    {
        self.data = data
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateBar(expand : Bool)
    {
        if  expand
        {
            UIView.animateWithDuration(0.2,delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                var height = self.originalFrame?.size.height
                var yOrigin = self.originalFrame?.origin.y
                self.frame = CGRectMake(self.frame.origin.x, yOrigin! - self.adjustmentHeight, self.frame.size.width, height! + self.adjustmentHeight)
                self.alpha = 0.5
                }, completion: { (Bool) -> Void in
            })
        }
        else
        {
            UIView.animateWithDuration(0.2,delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                var height = self.originalFrame?.size.height
                var yOrigin = self.originalFrame?.origin.y
                self.frame = CGRectMake(self.frame.origin.x, yOrigin!, self.frame.size.width, height!)
                self.alpha = 0.1
                }, completion: { (Bool) -> Void in
            })
        }

    }
    
}