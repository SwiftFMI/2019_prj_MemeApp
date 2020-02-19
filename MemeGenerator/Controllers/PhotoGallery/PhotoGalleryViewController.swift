//
//  PhotoGalleryViewController.swift
//  MemeGenerator
//
//  Created by Guest Account with permissions on 19.02.20.
//  Copyright © 2020 Ralitsa Dobreva. All rights reserved.
//

import UIKit

let reuseIdentifier = "PhotoCell"

class PhotoGalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    
    @IBOutlet weak var collectionView: UICollectionView!
            
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBackground()
    }

    private func setupBackground() {
        let gradient = CAGradientLayer()
        gradient.frame.size = view.frame.size
        gradient.startPoint = CGPoint(x: 0, y:0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.colors = [ #colorLiteral(red: 0.5058823529, green: 0.8784313725, blue: 0.5058823529, alpha: 1).cgColor , #colorLiteral(red: 0.1960784314, green: 0.8039215686, blue: 0.1960784314, alpha: 1).cgColor, #colorLiteral(red: 0.3215686275, green: 0.8352941176, blue: 0.3215686275, alpha: 1).cgColor]
        view.layer.insertSublayer(gradient, at: 0)
        collectionView.backgroundColor = #colorLiteral(red: 0.2235294118, green: 0.8549019608, blue: 0.2235294118, alpha: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 50
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell( withReuseIdentifier: reuseIdentifier, for: indexPath) as UICollectionViewCell
        
        cell.backgroundColor = UIColor.red
        
        return cell
    }

}
