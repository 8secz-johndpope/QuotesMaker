//
//  Saving.swift
//  QuotesMaker
//
//  Created by Shadrach Mensah on 24/04/2019.
//  Copyright © 2019 Shadrach Mensah. All rights reserved.
//

import Foundation


extension BaseView{
    
    func generatebaseModels()->[BaseModel]{
        
        let largeModel = subviews.compactMap { (subview) -> BaseModel? in
            guard let baseSub = subview as? BaseSubView else {return nil}
            if let rect = baseSub as? RectView{
                let rectMod = rect.model
                let baseModel = BaseModel(type: .shape, model: rectMod)
                return baseModel
            }
            if let text = baseSub as? BackingTextView{
                let textMod = text.model
                let baseModel = BaseModel(type: .text, model: textMod)
                return baseModel
            }
            
            if let image = baseSub as? BackingImageView{
                image.generateImageSource()
                print(image.model.imageSrc)
                let imgMod = image.model
                let baseModel = BaseModel(type: .image, model: imgMod)
                return baseModel
            }
            return nil
        }
        
        
        //let basemodels =  BaseModelCollection(models: largeModel)
        return largeModel
    }
    
    func constructFrom(model:[StudioModel]){
        
    }
    
    func duplicateLayer(id:UUID){
        
    }
    
    func getThumbnailSrc()->URL?{
        guard let image = makeImageFromView(size: nil) else {return nil}
        let id = UUID().uuidString
        let url = URL(fileURLWithPath: id, relativeTo: FileManager.previewthumbDir).addExtension(.jpg)
        let data = image.jpegData(compressionQuality: 0.5)
        do{
            try data?.write(to: url)
            return url
        }catch  let err {
            print(":Error Occurred: \(err.localizedDescription)")
        }
        
        return nil
    }
    
}
