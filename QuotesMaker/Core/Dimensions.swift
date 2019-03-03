//
//  Dimensions.swift
//  QuotesMaker
//
//  Created by Shadrach Mensah on 28/02/2019.
//  Copyright © 2019 Shadrach Mensah. All rights reserved.
//

import UIKit


class Dimensions{
    
    class func sizedRectForScale(rectSize:CGSize, scale:CGFloat)->CGSize{
        return [rectSize.width * scale, rectSize.height * scale ]
    }
    
    class var panelWidth:CGFloat{
        return UIScreen.main.bounds.width - 16
    }
    
    class var designatedHeight:CGFloat{
        return UIScreen.main.bounds.height * 0.3
    }
    
    class func heightForPanel(_ panel:Int)->CGFloat{
        if panel == 1{
            return min(200, designatedHeight)
        }else{
            return min(300, designatedHeight)
        }
    }
    
    
    class var originalPanelPoints:CGPoint{
        return [8,UIScreen.main.bounds.height + 300]
    }
    
    class func scaledDownFrom(rect:CGSize)->CGSize{
        let lowestSide = min(rect.width, rect.height)
        let maxSide = CGFloat.fixedWidth
        let scaler = maxSide / lowestSide
        return rect.scaledBy(scaler)
        
    }
    
    enum AspectRatios{
        case `default`
        case square
    }
    
    class func sizeForAspect(_ ratio:AspectRatios)-> CGSize{
        switch ratio {
        case .default:
            return [.fixedWidth, .fixedWidth * (9 / 16)]
        case .square:
            return [.fixedWidth]
        }
    }
    
}
