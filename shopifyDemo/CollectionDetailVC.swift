//
//  CollectionDetailVC.swift
//  shopifyDemo
//
//  Created by Jerry Wang on 3/23/19.
//  Copyright © 2019 Jerry Wang. All rights reserved.
//

import UIKit
//define an enumeration to store the values of the section indices in the tableview
enum TableSection:Int{
    case Header = 0, Product, Total
}

//the 'detail' screen of the application, hosting the cotent for a specific custom collection
class CollectionDetailVC: UITableViewController {
    
    var dataSource:DataSource?
    var dataSourceDependency:MainCollectionResponse.CollectionItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = DataSource(collectionItem:dataSourceDependency,tableView: self.tableView)
    }

    //this tableview has two sections: a profile section for the collection and a products section
    override func numberOfSections(in tableView: UITableView) -> Int {
        return TableSection.Total.rawValue
    }
    //profile section has only 1 row
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.numberOfRows(inSection: section) ?? 0
    }

    //estimated height for optimization purposes
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section==TableSection.Header.rawValue ? self.view.frame.width:UITableView.automaticDimension
    }
    //define section header title
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource?.title(forSection: section) ?? ""
    }
    //define content of each cell by asking data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let dataSource = dataSource {
            return dataSource.tableViewCell(forIndexPath: indexPath)
        } else {
            let blankCell = UITableViewCell(style: .default, reuseIdentifier: "detail")
            blankCell.textLabel?.text = "Please wait, retrieving..."
            return blankCell
        }
    }
}
