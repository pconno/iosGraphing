//
//  CLLBarOverlayData.swift
//  CLLCharts
//
//  Created by Phillip Connaughton on 11/24/14.
//  Copyright (c) 2014 cll. All rights reserved.
//

import Foundation
import UIKit

class CLLBarOverlayData : NSObject {
    var x : CGFloat
    var data : NSDictionary
    var width : CGFloat?
    
    init(x : CGFloat, data : NSDictionary)
    {
        self.x = x
        self.data = data
    }
}
