//
//  PhotoViewController.swift
//  MemeGenerator
//
//  Created by Guest Account with permissions on 19.02.20.
//  Copyright © 2020 Ralitsa Dobreva. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    @IBAction func exportButton(_ sender: Any) {
        print("export")
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}
