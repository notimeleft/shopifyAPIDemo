//
//  CustomCollectionsVC.swift
//  shopifyDemo
//
//  Created by Jerry Wang on 3/21/19.
//  Copyright © 2019 Jerry Wang. All rights reserved.
//

import UIKit

//The main screen of the application, which hosts a list of all the custom collections
class CustomCollectionsVC: UITableViewController{
    
    var mainCollection:MainCollectionResponse?
    var detailCollectionItem:MainCollectionResponse.CollectionItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.title = "Custom Collections"
        loadCollectionTitles()
    }
    
    //gather the list of custom collections and load it into the tableview
    func loadCollectionTitles(){
        if let url = MainRequestURL(){
            basicNetworkRequest(url: url){
                [unowned self] (data) in
                let results = try JSONDecoder().decode(MainCollectionResponse.self, from: data)
                self.mainCollection = results
                DispatchQueue.main.async {
                    [unowned self] in
                    self.tableView.reloadData()
                }
            }
        }
    }
    //preparation actions before transitioning to collection detail view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail"{
            let collectionsDetail = segue.destination as! CollectionDetailVC
            collectionsDetail.collectionItem = detailCollectionItem
        }
    }
    //tableview delegate method: define number of rows in each section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainCollection?.custom_collections.count ?? 1
    }
    //define cell content
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "main", for: indexPath)
        if let mainCollection = mainCollection{
            cell.textLabel?.text = mainCollection.custom_collections[indexPath.row].title
        } else {
            cell.textLabel?.text = "please wait, retrieving..."
        }
        return cell
    }
    //define what happens when user taps on a specific cell. In this case, we gather the selected collection item and perform a segue to the detail view controller
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let collectionItem = mainCollection?.custom_collections[indexPath.row] {
            detailCollectionItem = collectionItem
            performSegue(withIdentifier: "showDetail", sender: self)
        }
    }
    

}

