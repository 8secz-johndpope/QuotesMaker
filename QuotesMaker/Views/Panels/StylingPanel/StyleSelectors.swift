//
//  Selectors.swift
//  QuotesMaker
//
//  Created by Shadrach Mensah on 28/03/2019.
//  Copyright © 2019 Shadrach Mensah. All rights reserved.
//

import UIKit


extension StylingPanel{
    
    @objc func borderColorChanged(_ slider:ColorSlider){
        style.borderColor = slider.color
        delegate?.didFinishStyling(style)
    }
    
    @objc func borderWidthChanged(_ stepper:UIStepper){
        style.borderWidth = CGFloat(stepper.value)
        borderPanel.borderWidth.text = "Width: \(stepper.value)"
        delegate?.didFinishStyling(style)
        
    }
    
    @objc func cornerRadiusChanged(_ slider:UISlider){
        style.cornerRadius = CGFloat(slider.value)
        cornerPanel.cornerlable.text = "Radius: \(Int(slider.value))"
        delegate?.didFinishStyling(style)
    }
    
    @objc func shadowColorChanged(_ slider:ColorSlider){
        
    }
    
    @objc func shadowColorChanging(_ slider:ColorSlider){
        
    }
    
    @objc func shadowRadiusChanged(_ slider:UIStepper){
        
    }
    
    @objc func shadowXChanged(_ slider:ColorSlider){
        
    }
    
    @objc func shadowYChanged(_ slider:ColorSlider){
        
    }
    
    @objc func shadowOpacityChanged(_ slider:ColorSlider){
        
    }
    
    @objc func shadowOpacityChanging(_ slider:UISlider){
        
    }
    
}
