//
//  QMEngine.swift
//  QuotesMaker
//
//  Created by Shadrach Mensah on 02/03/2019.
//  Copyright © 2019 Shadrach Mensah. All rights reserved.
//

import Foundation



class QMEngine:NSObject{
    
   
    
    var currentProcess:Processes.Process = .createImagebackground
    
    override init() {}
    
    func  next(_ opcode:Int)-> Processes.Process{
        switch opcode {
        case 1:
            return .createImagebackground
        default:
            return .createImagebackground
        }
    }
}


struct Processes {
    enum Process{
        case createImagebackground,addShape,createText,home, preview, manage
        
    }
    
    enum SubProcesses:CaseIterable {
        case home
        case addShadpe
        case selectImage
        case addText
        case preview
        case save
        case startOver
    }
    
    let name: String
    let process:Process
    let subProcess:SubProcesses
    
    
    
    static func getAllProcesses()->[Processes]{
        var sub:[Processes] = []
        for i in SubProcesses.allCases{
            var s:String
            var p:Process
            switch i{
            case .home:
                s = "Home"
                p = .home
            case .selectImage:
                s = "Add Image"
                p = .createImagebackground
                break
            case .addShadpe:
                s = "Add Shape"
                p = .addShape
            case .addText:
                s = "Add Text"
                p = .createText
            case .preview:
                s = "Preview"
                p = .preview
            case .save:
                s = "Save"
                p = .manage
            case .startOver:
                s = "Start Over"
                p = .manage
            }
            let pros = Processes(name: s, process: p, subProcess: i)
            sub.append(pros)
        }
        return sub
    }
}
