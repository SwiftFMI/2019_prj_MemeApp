//
//  PhotoGalleryViewController.swift
//  MemeGenerator
//
//  Created by Nikola Bratanov on 19.02.20.
//  Copyright © 2020 Ralitsa Dobreva. All rights reserved.
//

import UIKit
import Kingfisher
import Photos

class PhotoGalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
            
    private var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getImages()
        setupBackground()
        
        collectionView.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.RawValue(UInt8(UIView.AutoresizingMask.flexibleWidth.rawValue) | UInt8(UIView.AutoresizingMask.flexibleHeight.rawValue)))
        
    }

    override func viewWillAppear(_ animated: Bool) {
              
        self.collectionView.reloadData()
    }

    func getImages() {
        for item in StorageManager.shared.memes {
            guard let url = URL(string: item) else { continue }
            let data = try? Data(contentsOf: url)
            let image = UIImage(data: data! as Data)!
            images.append(image)
        }
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
        
        return StorageManager.shared.memes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        
        guard let url = URL(string: StorageManager.shared.memes[indexPath.row]) else { return cell }
        
        cell.image.kf.indicatorType = .activity
        cell.image.kf.setImage(with: url)

        cell.backgroundView = UIView(frame: cell.contentView.frame)
        cell.contentView.layer.cornerRadius = 10
        cell.backgroundView?.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        cell.backgroundView?.alpha = 0.3

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:( collectionView.frame.width - 5 ) / 2, height: (collectionView.frame.height - 10)/4)
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showFullView") {
            let vc: PhotoPreviewFullViewController = segue.destination as! PhotoPreviewFullViewController
            if let cell = sender as? UICollectionViewCell, let indexPath = collectionView.indexPath(for: cell) {
                vc.passedContentOffset = indexPath
            }
            vc.images = self.images
        }
    }

}
