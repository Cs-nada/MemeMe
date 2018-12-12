//
//  SentMemeCollectionController.swift
//  MemeMe
//
//  Created by Ndoo H on 13/12/2018.
//  Copyright © 2018 Ndoo H. All rights reserved.
//

import Foundation
import UIKit

class SentMemeCollectionController:UICollectionViewController {
    // config sharde model to acces the globle array
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet var viewCollection: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = false
        collectionView.reloadData()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return appDelegate.memes.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! CollectionViewCell
        
        let memes = appDelegate.memes[(indexPath as NSIndexPath).row]
        // Set the name and image
        cell.memeImageView?.image = memes.image
        cell.contentMode = .scaleAspectFit
        cell.topLabel?.text = memes.topText
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.selectedMeme = appDelegate.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
   
    
    
}
