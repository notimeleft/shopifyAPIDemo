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
    //class that handles receiving/returning data from a MainCollectionResponse
    class DataSource {
        var mainCollection:MainCollectionResponse? {
            didSet{
                populateData()
            }
        }
        var detailCollectionIndex = 0
        
        var numberOfRowsInSection:Int{
            return mainCollection?.custom_collections.count ?? 1
        }
        
        var detailCollectionItem:MainCollectionResponse.CollectionItem? {
            return mainCollection?.custom_collections[detailCollectionIndex]
        }
        
        private var tableView:UITableView?
        
        init(tableView:UITableView){
            self.tableView = tableView
            requestData()
        }
        
        func getCollectionTitle(inIndex index:Int)->String{
            return mainCollection?.custom_collections[index].title ?? ""
        }
        
        //gather the list of custom collections and load it into the tableview
        func requestData(){
            if let url = MainRequestURL(){
                basicNetworkRequest(url: url){
                    [unowned self] (data) in
                    let results = try JSONDecoder().decode(MainCollectionResponse.self, from: data)
                    self.mainCollection = results
                }
            }
        }
        //ask the tableview to reload the data
        private func populateData(){
            DispatchQueue.main.async {
                [unowned self] in
                self.tableView?.reloadData()
            }
        }
    }
    
    private var dataSource:DataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.title = "Custom Collections"
        dataSource = DataSource(tableView: self.tableView)
        //loadCollectionTitles()
    }
    
    
    //preparation actions before transitioning to collection detail view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail"{
            let collectionsDetail = segue.destination as! CollectionDetailVC
            collectionsDetail.dataSourceDependency = dataSource?.detailCollectionItem
        }
    }
    //tableview delegate method: define number of rows in each section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.numberOfRowsInSection ?? 1
    }
    //define cell content
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "main", for: indexPath)
        if let dataSource = dataSource{
            cell.textLabel?.text = dataSource.getCollectionTitle(inIndex: indexPath.row)
        } else {
            cell.textLabel?.text = "please wait, retrieving..."
        }
        return cell
    }
    //define what happens when user taps on a specific cell. In this case, we gather the selected collection item and perform a segue to the detail view controller
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let dataSource = dataSource{
            dataSource.detailCollectionIndex = indexPath.row
            performSegue(withIdentifier: "showDetail", sender: self)
        }
    }
}
