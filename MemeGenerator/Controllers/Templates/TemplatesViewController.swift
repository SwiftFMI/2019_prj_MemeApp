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
    @IBOutlet weak var searchBar: UISearchBar!
    
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.layer.cornerRadius = 10
        setupBackground()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        StorageManager.shared.searchedImages = []
        isSearching = false
        searchBar.text = ""
        addButton.center.x -= 20
        searchBar.alpha = 0
        addButton.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.addButton.center.x += 20
            self.addButton.alpha = 1
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.1, options: [.transitionCurlDown], animations: {
            self.searchBar.alpha = 1
        }, completion: nil)
        
        collectionView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        showImagePickerControllerActionSheet()
        
    }
    
    private func setupBackground() {
        let gradient = CAGradientLayer()
        gradient.frame.size = view.frame.size
        gradient.startPoint = CGPoint(x: 0, y:0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.colors = [ #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1).cgColor , #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1).cgColor, #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1).cgColor]
        view.layer.insertSublayer(gradient, at: 0)
        collectionView.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
    }
    
}

extension TemplatesViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearching {
            return StorageManager.shared.searchedImages.count
        }
        return StorageManager.shared.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TemplateCollectionViewCell", for: indexPath) as! TemplateCollectionViewCell
        
        var url: URL?
        if isSearching {
            url = URL(string: StorageManager.shared.searchedImages[indexPath.row] )
        } else {
            url = URL(string: StorageManager.shared.images[indexPath.row] )
        }
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.alpha = 0
        
        UIView.animate( withDuration: 0.4, delay: 0.02 * Double(indexPath.row),
                        animations: {
                            cell.alpha = 1
        })
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
        
        StorageManager.shared.uploadTemplates(url: imageURL.absoluteURL, complition: {
            success in
            if success, !self.isSearching {
                let indexPath = IndexPath(row: StorageManager.shared.images.count - 1, section: 0 )
                self.collectionView.insertItems(at: [indexPath])
                self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
            }
             picker.dismiss(animated: true)
            
        })
       
    }
}


extension TemplatesViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        searchBar.text = nil
        collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        
        guard let searchWord = searchBar.text else {
            return
        }
        if !searchWord.isEmpty {
            isSearching = true
            StorageManager.shared.searchTemplates(searchWord)
            collectionView.reloadData()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
}
