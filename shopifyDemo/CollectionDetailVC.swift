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
    case Profile = 0
    case Product = 1
}

//the 'detail' screen of the application, hosting the cotent for a specific custom collection
class CollectionDetailVC: UITableViewController {
    //a list of products
    var productItems:[ProductResponse.Product]?
    //the collection item specific to this screen
    var collectionItem: MainCollectionResponse.CollectionItem!
    //the collection image
    var collectionImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCollectionPicture()
        loadProductInfo()
    }
    //request the collection picture from the image src link, load it into the tableview
    func loadCollectionPicture(){
        if let imageURL = URL(string:collectionItem.image.src){
            basicNetworkRequest(url: imageURL){
                [weak self] (data) in
                self?.collectionImage = UIImage(data:data)
                DispatchQueue.main.async{
                    [weak self] in
                    self?.tableView.reloadData()
                }
            }
        }
    }
    //request the collection's products, load into tableview
    func loadProductInfo(){
        if let infoURL = CollectionRequestURL(id: collectionItem.id){
            basicNetworkRequest(url: infoURL){
                [weak self] (data) in
                let results = try JSONDecoder().decode(SingleCollectionResponse.self, from: data)
                
                let productIDs = results.collects.map {$0.product_id}
                let idParam = productIDs.map {String($0)}.joined(separator: ",")
                if let productURL = ProductRequestURL(id: idParam){
                    self?.basicNetworkRequest(url: productURL){
                        [weak self](data) in
                        let products = try JSONDecoder().decode(ProductResponse.self, from: data)
                        self?.productItems = products.products
                        self?.loadProductPictures()
                        DispatchQueue.main.async{
                            [weak self] in
                            self?.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    //easily the hardest part of this app. We have to make a network request for every single product's picture, and we have to be able to update the table whenever the image has been fetched. This means we must assign the image value to the correct 'product' object in the array, which means the Product data structure cannot be a struct. 
    func loadProductPictures(){
        guard let productItems = productItems else { return }
        for product in productItems{
            if let imageLink = product.images.first?.src, let url = URL(string: imageLink){
                basicNetworkRequest(url: url){
                    [weak self] (data) in
                    
                    product.firstImage = data
                    DispatchQueue.main.async{
                        self?.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    
    //this tableview has two sections: a profile section for the collection and a products section
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    //profile section has only 1 row
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section==TableSection.Profile.rawValue ? 1:(productItems?.count ?? 0)
    }
    //define custom height for the profile section
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section==TableSection.Profile.rawValue ? self.view.frame.width:UITableView.automaticDimension
    }
    //estimated height for optimization purposes
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section==TableSection.Profile.rawValue ? self.view.frame.width:UITableView.automaticDimension
    }
    //define section header title
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == TableSection.Profile.rawValue ? collectionItem.title:"Products"
    }
    //define content of each cell: if it's a profile cell, put the profile picture and body html in. Else, put the product info in. 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == TableSection.Profile.rawValue{
            let cell = tableView.dequeueReusableCell(withIdentifier: "header", for: indexPath) as! ProfilePictureCell
            if let collectionImage = collectionImage{
                cell.profilePictureView.image = collectionImage
            }
            cell.descriptionLabel.text = collectionItem.body_html
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "detail", for: indexPath)
            if let product = productItems?[indexPath.row]{
                cell.textLabel?.text = String(product.title)
                cell.detailTextLabel?.text = String(product.quantity)
                if let pictureData = product.firstImage{
                    cell.imageView?.image = UIImage(data:pictureData)
                }
            } else {
                cell.textLabel?.text = "Please wait, retrieving..."
            }
            return cell
        }
    }
}
