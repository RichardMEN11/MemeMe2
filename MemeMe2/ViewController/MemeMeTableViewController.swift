//
//  MemeMeTableViewController.swift
//  MemeMe2
//
//  Created by Richard Menning on 15.05.18.
//  Copyright © 2018 Richard Menning. All rights reserved.
//

import UIKit

class MemeMeTableViewController: UITableViewController {
    
    
var memes: [Meme]?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes?.count ?? 0
    }
}
