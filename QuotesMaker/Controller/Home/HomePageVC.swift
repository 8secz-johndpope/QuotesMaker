//
//  HomePageVC.swift
//  QuotesMaker
//
//  Created by Shadrach Mensah on 29/04/2019.
//  Copyright © 2019 Shadrach Mensah. All rights reserved.
//

import UIKit

class HomePageVC: UIViewController {
    
    @IBOutlet weak var recentCollectionVIew: UICollectionView!
    @IBOutlet weak var templatesCollection: UICollectionView!
    @IBOutlet weak var dimensionsProjectCollection: UICollectionView!
    
    private var allModels:[StudioModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        // Do any additional setup after loading the view.
    }
    
    func setup(){
        recentCollectionVIew.register(UINib(nibName: "\(TemplateCell.self)", bundle: nil), forCellWithReuseIdentifier: "\(TemplateCell.self)")
        //recentCollectionVIew.register(UINib(nibName: "\(TemplateCell.self)", bundle: nil), forCellWithReuseIdentifier: "\(TemplateCell.self)")
    }

}


extension HomePageVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allModels.count
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(TemplateCell.self)", for: indexPath) as! TemplateCell
        let mod = allModels[indexPath.row]
        cell.configureView(src: mod.thumbImageSrc!, name: mod.name)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return [200]
    }
}
