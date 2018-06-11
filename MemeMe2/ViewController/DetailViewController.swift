//
//  DetailViewController.swift
//  MemeMe2
//
//  Created by Richard Menning on 11.06.18.
//  Copyright © 2018 Richard Menning. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var detailImageView: UIImageView!
    
    var meme: Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        detailImageView.image = meme.memedImage
        detailImageView.contentMode = .scaleAspectFit
    }


}
