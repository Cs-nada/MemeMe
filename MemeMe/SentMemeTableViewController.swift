//
//  SentMemeTableViewController.swift
//  MemeMe
//
//  Created by Ndoo H on 12/12/2018.
//  Copyright © 2018 Ndoo H. All rights reserved.
//

import Foundation
import UIKit

class SentMemeTableViewController : UITableViewController {
    
    // config sharde model to acces the globle array
  let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //Outlets
  @IBOutlet var sentMemesTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
        setDefaultUIState()
    }
    
    private func setDefaultUIState() {
        sentMemesTableView.reloadData()
        tabBarController?.tabBar.isHidden = false

       
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SentMemesTableViewCell", for: indexPath as IndexPath)
        let memes = appDelegate.memes[(indexPath as NSIndexPath).row]
        // Set the name and image
        cell.imageView?.image = memes.image
        cell.textLabel?.text = memes.topText
        return cell
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMeme = appDelegate.memes[indexPath.row]
         let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        
        detailController.selectedMeme = selectedMeme
        
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
      return true
    }
   
    
}
