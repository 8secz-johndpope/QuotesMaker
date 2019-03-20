//
//  ImageModel.swift
//  QuotesMaker
//
//  Created by Shadrach Mensah on 08/03/2019.
//  Copyright © 2019 Shadrach Mensah. All rights reserved.
//

import UIKit


struct ImageLayerModel:LayerModel {
    
    var layerFrame:LayerFrame?
    
    mutating func layerFrame(_ frame: LayerFrame) {
        self.frame = frame
    }
    
    //private var _image:UIImage?
    var image:UIImage?

    
    mutating func update(withValue value: UIImage) {
        
        
    }
    
    
    
    var frame:LayerFrame?
    
    init(image:UIImage? = nil) {
        self.image = image
    }
    
}


