//
//  EditingCoordinator.swift
//  QuotesMaker
//
//  Created by Shadrach Mensah on 05/04/2019.
//  Copyright © 2019 Shadrach Mensah. All rights reserved.
//

import UIKit
import Photos


class EditingCoordinator:NSObject{
    
    var baseView:BaseView
    weak var delegate:EditingCoordinatorDelegate?
    var existingModel:StudioModel?
    
    override init(){
        
        baseView = BaseView(frame: .zero)
        let size = Dimensions.sizeForAspect(.square)
        baseView.frame = CGRect(origin: .zero, size: size)
        super.init()
    }
    
    init(model:StudioModel){
        baseView = BaseView(frame: .zero)
        let size = Dimensions.sizeForAspect(.square)
        baseView.frame = CGRect(origin: .zero, size: size)
        existingModel = model
        super.init()
        baseView.constructFrom(model: model)
    }
    
    var  layerDatasource:Alias.StackDataSource{
        guard let layers = baseView.subviews as? Alias.StackDataSource else {return []}
        return layers
    }
    
    func imageOptionSelected(){
        
        let imageView = BackingImageView(frame: baseView.subBounds)
        baseView.addSubviewable(imageView)
        imageView.model.layerFrame = imageView.makeLayerFrame()
        
    }
    
    
    func deleteCurrent(){
        if let current = baseView.currentSubview{
            current.removeFromSuperview()
            baseView.currentSubview = nil
            
        }
    }
   
    
    func shapeSelected(){
        let shape = RectView(frame: baseView.subBounds)
        baseView.addSubviewable(shape)
        shape.model.layerFrame = shape.makeLayerFrame()
       
        
    }
    
    
    func addText(){
        let textField = BackingTextView(frame: baseView.textBound)
        
        baseView.addSubviewable(textField)
        textField.model.layerFrame = textField.makeLayerFrame()
        if UIDevice.idiom == .phone{
            textField.addDoneButtonOnKeyboard()
        }
    }
    
    func moveSubiewForward(){
        baseView.moveSubiewForward()
    }
    
    func moveSubiewBackward(){
        baseView.moveSubiewBackward()
    }
    
    func save(message:String = "Enter project name"){
        //TODO: Verify pais user or throw alert to buy app
        //TODO: Verify name does not exist before saving
        if existingModel == nil{
            let alert = UIAlertController(title:"Save Project", message:message, preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (ac) in
                let text = alert.textFields?.first!.text
                self.persistModel(title: text ?? "untitled")
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        }
        

    }
    
    func persistModel(title:String){
        if title == ""{save(message: "Enter a valid name for project")}
        if Persistence.main.fileExists(name: title, with: .json, in: .savedModels){
            save(message: "Project already exists with name \(title), choose a new project name")
        }
        let mods = baseView.generatebaseModels()
        let thumb = baseView.getThumbnailSrc()
        if existingModel == nil{
            existingModel = StudioModel(models: mods,name:title, url:thumb)
            
        }else{
            existingModel?.update(models: mods, src: thumb, bg: baseView.backgroundColor)
        }
        
        Persistence.main.save(model: existingModel!)
    }
    
}


extension EditingCoordinator:StylingDelegate{
    
    func didFinishStyling(_ style: Style) {
        if let current = baseView.currentSubview as? RectView{
            var model = current.model
            model.style = style
            current.updateModel(model)
        }else if let current = baseView.currentSubview as? BackingImageView{
            var model = current.model
            model.style = style
            current.updateModel(model)
        }
    }
    
    func didFinishPreviewing(_ style: Style) {
        if let current = baseView.currentSubview as? RectView{
            var model = current.model
            model.style = style
            current.model = model
        }else if let current = baseView.currentSubview as? BackingImageView{
            var model = current.model
            model.style = style
            current.model = model
        }
    }
    
}



extension EditingCoordinator:PickerColorDelegate{
    
    
    
    func colorDidChange(_ model: BlankLayerModel) {
        guard let current = baseView.currentSubview as? ShapableView else {return}
        var mod = current.model
        mod.isGradient = false
        mod.solid = model
        current.updateModel(mod)
    }
    
    //To visit during State Changeable
    func previewingWith(_ model: BlankLayerModel) {
        guard var current = baseView.currentSubview as? ShapableView else {return}
        var mod = current.model
        mod.isGradient = false
        mod.solid = model
        current.model = mod
    }
    
}

extension EditingCoordinator:GradientOptionsDelegate{
    
    func modelChanged(_ model: GradientLayerModel) {
        guard let current = baseView.currentSubview as? ShapableView else {return}
        var mod = current.model
        mod.gradient = model
        mod.isGradient = true
        current.updateModel(mod)
    }
    
}


extension EditingCoordinator:ImagePanelDelegate{
    
    func didSelect(_ option: ImagePanel.PanelOptions) {
        
        switch option {
        case .gallery:
            delegate?.launchImagePicker()
            break
        case .online:
            break
        case .rotate:
            guard let current = baseView.currentSubview as? BackingImageView else {break}
            current.rotateImage()
            break
        case .cropMode:
            delegate?.beginCroppingImage()
            break
        case .flipHorizontal:
            flipImage(.horizontal)
            break
        case .flipVertical:
            flipImage(.vertical)
            break
        }
    }
    
    func flipImage(_ side:BackingImageView.FlipSides){
        if let current = baseView.currentSubview as? BackingImageView{
            current.flip(side)
        }
    }
}

extension EditingCoordinator:FetchedAssetDelegate{
    
    func didPickImage(image:UIImage){
        if let base = baseView.currentSubview as? BackingImageView{
            base.setImage(image: image)
        }
    }


}


extension EditingCoordinator:StackTableDelegate{
    func didDismiss() {
        //
    }
    
    
    
    func didSelectView(with uid: UUID) {
        let view = layerDatasource.first{$0.uid == uid}
        print(view ?? "No view Found. Casting error || Use LLDB `po assert(type(of:baseView.subviews) == Alias.StackDataSource.self)`")
        if let sub = view as? RectView {
            baseView.currentSubview = sub
            
        }else if let sub = view as? BackingImageView{
            baseView.currentSubview = sub
        }else if let sub = view as? BackingTextView{
            baseView.currentSubview = sub
        }
    }
    
    
}


