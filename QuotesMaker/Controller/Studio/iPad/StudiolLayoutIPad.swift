//
//  StudiolLayoutIPad.swift
//  QuotesMaker
//
//  Created by Shadrach Mensah on 02/04/2019.
//  Copyright © 2019 Shadrach Mensah. All rights reserved.
//

import Foundation


extension iPadStudioVC{
    
    func iPadLayout(){
        taskbarContainer.layout{
            $0.top == view.topAnchor + 30
            $0.leading == view.leadingAnchor
            $0.trailing == view.trailingAnchor
            $0.height |=| 120
        }
        
        taskbar.view.layout{
            $0.top == taskbarContainer.topAnchor
            $0.bottom == taskbarContainer.bottomAnchor
            $0.trailing == taskbarContainer.trailingAnchor
            $0.leading == taskbarContainer.leadingAnchor
        }
        
        controlPanelContainer.layout{
            $0.top == taskbarContainer.bottomAnchor
            $0.trailing == view.trailingAnchor
            $0.bottom == view.bottomAnchor
            $0.width |=| Dimensions.iPadContext.controlPanelWidth
        }
        
        layerStack.layout{
            $0.top == taskbarContainer.bottomAnchor
            $0.leading == view.leadingAnchor -- layerStack.constraintIds.leading
            $0.bottom == view.bottomAnchor
            $0.width |=| Dimensions.iPadContext.layerStackWidth
        }
        
        editor.layout{
            $0.top == taskbarContainer.bottomAnchor
            $0.leading == layerStack.trailingAnchor
            $0.trailing == controlPanelContainer.leadingAnchor
            $0.bottom == view.bottomAnchor - 2
        }
        
//        studioPanel.layout{
//            $0.bottom == view.bottomAnchor
//            $0.leading == view.leadingAnchor
//            $0.trailing == view.trailingAnchor
//            $0.height |=| studioHeight
//        }
    }
    
    func forceInterfaceForlandscape(){
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
//        if UIDevice.current.userInterfaceIdiom == .phone{
//            return .portrait
//        }else {
//            return .landscape
//        }
//    }
//    
//    override var shouldAutorotate: Bool{
//        if UIDevice.current.userInterfaceIdiom == .phone{
//            return false
//        }else {
//            return true
//        }
//    }
}
