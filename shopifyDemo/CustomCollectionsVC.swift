//
//  CustomCollectionsVC.swift
//  shopifyDemo
//
//  Created by Jerry Wang on 3/21/19.
//  Copyright © 2019 Jerry Wang. All rights reserved.
//

import UIKit

class CustomCollectionsVC: UITableViewController{
//    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var mainCollection:MainCollectionResponse?
    var detailCollectionItem:MainCollectionResponse.CollectionItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.title = "Custom Collections"
        requestMainCollection()
    
    }
    //preparation actions before transitioning to collection detail view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail"{
            let collectionsDetail = segue.destination as! CollectionDetailVC
            collectionsDetail.collectionItem = detailCollectionItem
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainCollection?.custom_collections.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "main", for: indexPath)
        if let mainCollection = mainCollection{
            cell.textLabel?.text = mainCollection.custom_collections[indexPath.row].title
        } else {
            cell.textLabel?.text = "please wait, retrieving..."
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let collectionItem = mainCollection?.custom_collections[indexPath.row] {
            detailCollectionItem = collectionItem
            performSegue(withIdentifier: "showDetail", sender: self)
        }
    }
    

}

