//
//  PhotoViewController.swift
//  MemeGenerator
//
//  Created by Nikola Bratanov on 19.02.20.
//  Copyright © 2020 Ralitsa Dobreva. All rights reserved.
//

import UIKit

class PhotoPreviewFullViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var collectionView: UICollectionView!
    var images = [UIImage]()
    var passedContentOffset = IndexPath()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black
    
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PhotoPreviewFullViewCell.self, forCellWithReuseIdentifier: "PhotoPreviewFullViewCell")
        collectionView.isPagingEnabled = true
        collectionView.scrollToItem(at: passedContentOffset, at: .left, animated: true)
        
        self.view.addSubview(collectionView)
        
        collectionView.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.RawValue(UInt8(UIView.AutoresizingMask.flexibleWidth.rawValue) | UInt8(UIView.AutoresizingMask.flexibleHeight.rawValue)))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoPreviewFullViewCell", for: indexPath) as! PhotoPreviewFullViewCell
        cell.imgView.image = self.images[indexPath.row]
        
        return cell
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        flowLayout.itemSize = collectionView.frame.size
        flowLayout.invalidateLayout()
        
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let offset = collectionView.contentOffset
        let width  = collectionView.bounds.size.width
        
        let index = round(offset.x / width)
        let newOffset = CGPoint(x: index * size.width, y: offset.y)
        
        collectionView.setContentOffset(newOffset, animated: false)
        
        coordinator.animate(alongsideTransition: { (context) in
            self.collectionView.reloadData()
            
            self.collectionView.setContentOffset(newOffset, animated: false)
        }, completion: nil)
    }
}
