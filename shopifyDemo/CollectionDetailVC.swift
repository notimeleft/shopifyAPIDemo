//
//  CollectionDetailVC.swift
//  shopifyDemo
//
//  Created by Jerry Wang on 3/23/19.
//  Copyright © 2019 Jerry Wang. All rights reserved.
//

import UIKit

class CollectionDetailVC: UITableViewController {
    var productItems:[ProductResponse.Product]?

    var collectionItem: MainCollectionResponse.CollectionItem!
    var collectionImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestPicture()
        requestDetail(collectionID: collectionItem.id)
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section==0 ? 1:(productItems?.count ?? 0)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section==0 ? self.view.frame.width:UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section==0 ? self.view.frame.width:UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? collectionItem.title:"Products"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "header", for: indexPath) as! ProfilePictureCell
            if let collectionImage = collectionImage{
                cell.profilePictureView.image = collectionImage
            }
            cell.descriptionLabel.text = collectionItem.body_html
            //cell.textLabel?.text = collectionItem.title
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "detail", for: indexPath)
            if let title = productItems?[indexPath.row].title, let count = productItems?[indexPath.row].quantity{
                cell.textLabel?.text = String(title)
                cell.detailTextLabel?.text = String(count)
                //cell.imageView?.image = UIImage(named: "1.jpg")
            } else {
                cell.textLabel?.text = "Please wait, retrieving..."
            }
            return cell
        }
    }
}
