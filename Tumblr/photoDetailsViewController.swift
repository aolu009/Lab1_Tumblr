//
//  photoDetailsViewController.swift
//  Tumblr
//
//  Created by Lu Ao on 10/14/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//

import UIKit

class photoDetailsViewController: UIViewController {

    var image : UIImage?
    
    @IBOutlet weak var detailImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailImage.image = image
    }

}
