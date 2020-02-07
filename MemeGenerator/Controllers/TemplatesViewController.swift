//
//  ViewController.swift
//  MemeGenerator
//
//  Created by Ralitsa Dobreva on 4.02.20.
//  Copyright © 2020 Ralitsa Dobreva. All rights reserved.
//

import UIKit
import Kingfisher

class TemplatesViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StorageManager.shared.getTemplates {
            self.collectionView.reloadData()
        }
    }

    @IBAction func addButtonPressed(_ sender: Any) {
        
    }
    
}

extension TemplatesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return StorageManager.shared.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TemplateCollectionViewCell", for: indexPath) as! TemplatesCollectionViewCell
        cell.image.kf.indicatorType = .activity
        let url = URL(string: StorageManager.shared.images[indexPath.row] )
        cell.image.kf.setImage(with: url)
        
        return cell
    }
    
    
}
