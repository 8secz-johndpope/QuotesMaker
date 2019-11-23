//
//  BackingImageView.swift
//  QuotesMaker
//
//  Created by Shadrach Mensah on 08/03/2019.
//  Copyright © 2019 Shadrach Mensah. All rights reserved.
//

import UIKit

class BackingImageView: UIView{
    
    
    lazy var baseImageView:UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    lazy var resizerView:SPUserResizableView = { [unowned self] by in
        let resize = SPUserResizableView(frame: bounds)
        resize.minHeight = bounds.height * 0.1
        resize.minWidth = bounds.width * 0.1
        resize.preventsPositionOutsideSuperview = false
        resize.delegate = self
        
        return resize
        }(())
    
    
    func updateLayerFrame(model:ImageLayerModel){
        guard let lframe = model.layerFrame, let sup = superview else {return}
        let frame = lframe.awakeFrom(bounds: sup.bounds)
        self.frame = frame
        resizerView.frame = bounds
    }
    
    var image:UIImage?{
        didSet{
            baseImageView.image = image
            backgroundColor = .clear
            //imageSrc = UUID().uuidString.appending(".\(FileManager.Extensions.png)")
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    var oldmodel:ImageLayerModel = ImageLayerModel()
    
    var model:ImageLayerModel = ImageLayerModel(){
        didSet{
            //updateLayerFrame(model: model)
            changeMode()
            updateShape(model.style)
        }
    }
    
    private func changeMode(){
        let mode = model.mode
        switch mode {
        case .fill:
            baseImageView.contentMode = .scaleAspectFill
            break
        case .contain:
            baseImageView.contentMode = .scaleToFill
            break
        case .fit:
            baseImageView.contentMode = .scaleAspectFit
            break
        case .center:
            baseImageView.contentMode = .center
            break
        }
    }
    
    private func updateShape(_ style:Style){
        baseImageView.layer.cornerRadius = style.cornerRadius
        baseImageView.layer.borderWidth = style.borderWidth
        baseImageView.layer.borderColor = style.borderColor.cgColor
        transform = transform.rotated(by: .Angle(style.rotationAngle))
        /*contentView.*/layer.shadowColor = style.shadowColor.cgColor
        /*contentView.*/layer.shadowRadius = style.shadowRadius
        /*contentView.*/layer.shadowOpacity = style.shadowOpacity
        /*contentView.*/layer.shadowOffset = style.shadowOffset
    }
    
    func updateModel(_ model:ImageLayerModel){
        oldmodel = self.model
//        let state = State(model:oldmodel, action: .nothing)
//        Subscription.main.post(suscription: .stateChange, object: state)
        self.model = model
    
        
    }
    
    func generateImgFileName(){
        
    }
    
    var uid:UUID = UUID()
    
    func changeAspect(_ mode:ImageLayerModel.ContentMode){
        oldmodel = self.model
        model.mode = mode
        let state = State(model:oldmodel, action: .nothing)
        Subscription.main.post(suscription: .stateChange, object: state)
    }
    
    func setImage(image:UIImage){
        guard let image = image.fixImageOrientation() else {return}
        //let newImage = image.studioImage
       self.image = image
        //updateModel(new)
        //Subscription.main.post(suscription: .stateChange, object: true)
        //Subscription.main.post(suscription: .canUndo, object: true)
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notifications.Name.canUndo.rawValue), object: nil)
    }
    
    var id:String{
        return "Image \(id_tag)"
    }
    
    
    var id_tag: Int = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    func initialize(){
        backgroundColor = .clear
        baseImageView.clipsToBounds = true
        baseImageView.frame = resizerView.bounds
        resizerView.contentView = baseImageView
        addSubview(resizerView)
        model = ImageLayerModel()
        baseImageView.contentMode = .scaleAspectFill
        baseImageView.isUserInteractionEnabled = true
//        setResizableGesture()
//        setPanGesture()
        //movedInFocus()
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    
    }
    
    
    
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if let _ = superview{
            oldmodel.layerFrame = makeLayerFrame()
        }
    }
    
//    deinit {
//        if let name = model.imageSrc{
//            let url = URL(fileURLWithPath: name, relativeTo: FileManager.modelImagesDir)
//            Persistence.main.deleteFile(src: url)
//        }
//
//    }
    
    func addFilter(filter name:String){
        let loader = LoaderView(frame: bounds)
        addSubview(loader)
        //let opthread = DispatchQueue(label: name.rawValue, qos: .default)
        DispatchQueue.main.async { [unowned self] in
            
            guard let image = self.image else {loader.removeFromSuperview(); return}
            print("Unfiltered image size and count: \(image.size) :: \(image.pngData()?.count ?? 0)")
            if let filtered = FilterEngine().applyFilter(name: name, image: image){
                print("filtered image size and count: \(filtered.size) :: \(filtered.pngData()?.count ?? 0)")
                self.baseImageView.image = filtered
                loader.removeFromSuperview()
            }
        }
    }
    
    func confirmFilter(){
        if let bImage = baseImageView.image, let image = self.image{
            if image != bImage{
                self.image = bImage
            }
        }
    }
    
    func releaseImage(){
        if let name = model.imageSrc{
            let url = URL(fileURLWithPath: name, relativeTo: FileManager.modelImagesDir)
            Persistence.main.deleteFile(src: url)
        }
    }
    
    func generateImageSource(){
        guard let image = self.image else {return}
       
        if let name = model.imageSrc{
            let data = image.pngData()
            do{
                let url = URL(fileURLWithPath: name, relativeTo: FileManager.modelImagesDir)
                try data?.write(to: url)
                return
            }catch let err{
                print("Error occurred with sig: \(err.localizedDescription)")
            }
        }
         let name = UUID().uuidString.appending(".\(FileManager.Extensions.png)")
        let url = URL(fileURLWithPath:name , relativeTo: FileManager.modelImagesDir)
        let data = image.jpegData(compressionQuality: 0.3)
        do {
            try data?.write(to: url)
            model.imageSrc = name
        } catch let err {
            print("Error occurred with sig: \(err.localizedDescription)")
        }
    }
}




extension BackingImageView:BaseViewSubViewable{
    var layerModel: LayerModel {
        return model
    }
    
    func setIndex(_ index: CGFloat) {
        model.layerIndex = index
    }
    
    var getIndex:CGFloat{
        return model.layerIndex
    }
    
    func focused(_ bool:Bool){
        bool ? resizerView.showEditingHandles() : resizerView.hideEditingHandles()
    }
}

extension BackingImageView{
    
   
    
    enum FlipSides {
        case vertical,horizontal
    }
    
    func flip(_ side:FlipSides){
        guard let image =  image else {return}
        
        if side == .horizontal{
            let newImage:UIImage?
            if #available(iOS 10.0, *) {
                newImage = image.withHorizontallyFlippedOrientation()
            } else {
                newImage = rotate(image, degreeAngle: 180)
                // Fallback on earlier versions
            }
            
           self.image = newImage
            //updateModel(model)
        }else{
            guard let newImage = flipImageVertically(image: image)else {return}
            //var model = self.model
            self.image = newImage
            //updateModel(model)
        }
        
    }
    
    func rotateImage(){
        guard let image = image else {return}
//         currentAngle = currentAngle < 361 ? currentAngle + 90 : 0
//        transform = transform.rotated(by: .Angle(90))
        
        if let newImage = rotate(image){
            //image.rotate(radians: Float(CGFloat.Angle(90))){
            setImage(image: newImage)
            
        }
        
    }
    
    private func flipImageVertically(image:UIImage)->UIImage?{
       
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        guard let context = UIGraphicsGetCurrentContext() else {return nil}
        context.translateBy(x: image.size.width / 2, y: image.size.height / 2)
        context.scaleBy(x: image.scale, y: image.scale)
        
        context.translateBy(x: -image.size.width / 2, y: -image.size.height / 2)
        context.draw(image.cgImage!, in: CGRect(origin: .zero, size: image.size))
    
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    private func rotate(_ image:UIImage,degreeAngle:CGFloat = 90) -> UIImage?{
        
        var rotatedSize = CGRect(origin: .zero, size: image.size).applying(CGAffineTransform(rotationAngle: .Angle(degreeAngle))).size
        rotatedSize.width = floor(rotatedSize.width)
        rotatedSize.height = floor(rotatedSize.height)
        UIGraphicsBeginImageContextWithOptions(rotatedSize, false, image.scale)
        guard let context = UIGraphicsGetCurrentContext() else {return nil}
        let origin = CGPoint(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        context.translateBy(x: origin.x, y: origin.y)
        context.rotate(by: .Angle(90))
        image.draw(in: [-image.size.width / 2, -image.size.height / 2,image.size.width,image.size.height])
        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return rotatedImage
        
        
    }
}





extension BackingImageView:SPUserResizableViewDelegate{
    
    func userResizableViewDidBeginEditing(_ userResizableView: SPUserResizableView!) {
        if let superview = superview as? BaseView {
            superview.selectedView = self
        }
        userResizableView.showEditingHandles()
    }
    
    func userResizableViewDidEndEditing(_ userResizableView: SPUserResizableView!) {
        self.frame.size = resizerView.frame.size
        //print("The new frame is: \(resizerView.frame)")
        self.frame.origin = self.frame.origin + resizerView.frame.origin
        resizerView.frame.origin = .zero
        let old = model.layerFrame
        if old == makeLayerFrame(){return}
        model.layerFrame = makeLayerFrame()
        if model.layerFrame != oldmodel.layerFrame{
            Subscription.main.post(suscription: .stateChange, object: State(model: oldmodel, action: .nothing))
        }
    }
}


extension BackingImageView:NSCopying{
    func copy(with zone: NSZone? = nil) -> Any {
        let image = BackingImageView(frame: frame)
        image.model = model
        return image
    }
    

}
