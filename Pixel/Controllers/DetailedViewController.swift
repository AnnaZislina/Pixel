//
//  DetailedViewController.swift
//  Pixel
//
//  Created by Anna Zislina on 02/02/2020.
//  Copyright © 2020 Anna Zislina. All rights reserved.
//

import UIKit
import CoreData

class DetailedViewController: UIViewController {
    
    @IBOutlet weak var detailedImageView: UIImageView!
    @IBOutlet weak var detailedSizeLabel: UILabel!
    @IBOutlet weak var saveImageButton: RoundButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var linkLabel: LinkLabel!
    
   // var photo: Photo!
    var photo: PhotoModel!
    var dataController: DataController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailedSizeLabel.text = "Original size: \(photo.width) x \(photo.height)"
        detailedImageView.downloadImage(urlString: photo.src.original)
    }
}
