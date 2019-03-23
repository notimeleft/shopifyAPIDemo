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
        loadPicture()
        loadProductInfo()
        
    }
    
    func loadPicture(){
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
    
    func loadProductInfo(){
        if let infoURL = URL(string: "https://shopicruit.myshopify.com/admin/collects.json?collection_id=\(collectionItem.id)&page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"){
            basicNetworkRequest(url: infoURL){
                [weak self] (data) in
                let results = try JSONDecoder().decode(SingleCollectionResponse.self, from: data)
                
                let productIDs = results.collects.map {$0.product_id}
                let idParam = productIDs.map {String($0)}.joined(separator: ",")
                if let productURL = URL(string: "https://shopicruit.myshopify.com/admin/products.json?ids=\(idParam)&page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"){
                    self?.basicNetworkRequest(url: productURL){
                        [weak self](data) in
                        let products = try JSONDecoder().decode(ProductResponse.self, from: data)
                        self?.productItems = products.products
                        
                        DispatchQueue.main.async{
                            [weak self] in
                            self?.tableView.reloadData()
                        }
                    }
                }
            }
        }
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
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "detail", for: indexPath)
            if let title = productItems?[indexPath.row].title, let count = productItems?[indexPath.row].quantity{
                cell.textLabel?.text = String(title)
                cell.detailTextLabel?.text = String(count)
                
            } else {
                cell.textLabel?.text = "Please wait, retrieving..."
            }
            return cell
        }
    }
}
