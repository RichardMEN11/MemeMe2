//
//  MemeMeTableViewController.swift
//  MemeMe2
//
//  Created by Richard Menning on 15.05.18.
//  Copyright © 2018 Richard Menning. All rights reserved.
//

import UIKit

class MemeMeTableViewController: UITableViewController {
    
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
}
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! MemeTableViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        //adding the text
        cell.topText.text = meme.topText
        cell.bottomText.text = meme.bottomText
        cell.imageView?.contentMode = .scaleAspectFit
        cell.imageView?.image = meme.image
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = storyboard!.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        controller.meme = memes[indexPath.row]
        
        navigationController!.pushViewController(controller, animated: true)
    }

}
