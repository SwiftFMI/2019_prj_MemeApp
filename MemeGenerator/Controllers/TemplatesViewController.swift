//
//  ViewController.swift
//  MemeGenerator
//
//  Created by Ralitsa Dobreva on 4.02.20.
//  Copyright © 2020 Ralitsa Dobreva. All rights reserved.
//

import UIKit
import Kingfisher
import AVFoundation

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
        showImagePickerControllerActionSheet()
    }
    
}

extension TemplatesViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return StorageManager.shared.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TemplateCollectionViewCell", for: indexPath) as! TemplatesCollectionViewCell
        cell.image.kf.indicatorType = .activity
        let url = URL(string: StorageManager.shared.images[indexPath.row] )
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
    
}

extension TemplatesViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImagePickerControllerActionSheet() {
        let alert  = UIAlertController(title:  "Choose your image ", message: nil, preferredStyle: .actionSheet)
        let photoLibraryAction = UIAlertAction(title: "Choose from library", style: .default) { (action) in
            self.showImagePickerController(sourceType: .photoLibrary)
        }
        let cameraAction = UIAlertAction(title: "Take from Camera", style: .default) { (action) in
            self.showImagePickerController(sourceType: .camera)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(photoLibraryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func showImagePickerController(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = sourceType
        present(imagePickerController,animated: true)
    }
    
    func chekCameraPermission() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    func chekPhotoGalaryPermission() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard  let imageURL = info[.imageURL] as? NSURL else {
            return
        }
        
        StorageManager.shared.uploadImage( url: imageURL.absoluteURL, complition: { success in
            if success {
                let indexPath = IndexPath(row: StorageManager.shared.images.count - 1, section: 0 )
                self.collectionView.insertItems(at: [indexPath])
                picker.dismiss(animated: true)
            }
        })
    }
}
