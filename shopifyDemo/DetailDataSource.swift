//
//  DetailDataSource.swift
//  shopifyDemo
//
//  Created by Jerry Wang on 3/28/19.
//  Copyright © 2019 Jerry Wang. All rights reserved.
//

import UIKit
extension CollectionDetailVC{
    //This class is responsible for collecting and organizing the data displayed in the Detail screen's tableview
    class DataSource{
        //a list of products
        private var productItems:[ProductResponse.Product]?
        //the collection for this detail screen
        private var collectionItem:MainCollectionResponse.CollectionItem!
        //the collection's image
        var collectionImage:UIImage?{
            didSet{
                DispatchQueue.main.async{
                    [weak self] in
                    let indexPath = IndexPath(row: 0, section: 0)
                    self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        }
        //collection description
        var collectionDescription: String {
            return collectionItem.body_html
        }
        
        private var tableView:UITableView
        
        init(collectionItem:MainCollectionResponse.CollectionItem,tableView:UITableView){
            self.collectionItem = collectionItem
            self.tableView = tableView
            loadCollectionPicture()
            loadProducts()
        }
        
        func numberOfRows(inSection section:Int) -> Int {
            return section == TableSection.Header.rawValue ? 1:productItems?.count ?? 0
        }
        
        func title(forSection section:Int) -> String {
            return section == TableSection.Header.rawValue ? collectionItem?.title ?? "Collection":"Products"
        }
        
        func singleProductItem(inRow row:Int) -> ProductResponse.Product?{
            return productItems?[row]
        }
        
        private func loadCollectionPicture(){
            if let imageURL = URL(string:collectionItem.image.src){
                basicNetworkRequest(url: imageURL){
                    [weak self] (data) in
                    self?.collectionImage = UIImage(data:data)
                }
            }
        }
        
        private func loadProducts(){
            if let infoURL = CollectionRequestURL(id: collectionItem.id){
                basicNetworkRequest(url: infoURL){
                    [weak self] (data) in
                    let results = try JSONDecoder().decode(SingleCollectionResponse.self, from: data)
                    if let idParam = self?.getProductIDsParam(from: results),
                        let productURL = ProductRequestURL(id: idParam){
                        basicNetworkRequest(url: productURL){
                            [weak self](data) in
                            let products = try JSONDecoder().decode(ProductResponse.self, from: data)
                            self?.productItems = products.products
                            self?.loadProductPictures()
                            DispatchQueue.main.async{
                                [weak self] in
                                let indexSet = IndexSet(integer: 1)
                                self?.tableView.reloadSections(indexSet, with: .automatic)
                            }
                        }
                    }
                }
            }
        }
        
        private func getProductIDsParam(from collection: SingleCollectionResponse)->String{
            let productIDs = collection.collects.map {$0.product_id}
            return productIDs.map {String($0)}.joined(separator: ",")
        }
        
        //easily the hardest part of this app. We have to make a network request for every single product's picture, and we have to be able to update the table whenever the image has been fetched. This means we must assign the image value to the correct 'product' object in the array
        private func loadProductPictures(){
            guard let productItems = productItems else { return }
            
            for (index,product) in productItems.enumerated(){
                
                if let imageLink = product.images.first?.src, let url = URL(string: imageLink){
                    basicNetworkRequest(url: url){
                        //weak self not necessary!
                        [weak self] (data) in
                        
                        var product = product
                        product.firstImage = data
                        self?.productItems?[index]=product
                        DispatchQueue.main.async{
                            let indexPath = IndexPath(row: index, section: TableSection.Product.rawValue)
                            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                        }
                    }
                }
            }
        }
        
        func tableViewCell(forIndexPath indexPath:IndexPath)->UITableViewCell{
            //either return a header cell or the default 'detail' cell
            switch indexPath.section{
            case TableSection.Header.rawValue:
                let cell = tableView.dequeueReusableCell(withIdentifier: "header", for: indexPath) as! ProfilePictureCell
                
                cell.profilePictureView.image = self.collectionImage
                cell.descriptionLabel.text = self.collectionDescription
                
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "detail", for: indexPath)
                if let product = singleProductItem(inRow: indexPath.row){
                    cell.textLabel?.text = product.title
                    cell.detailTextLabel?.text = String(product.quantity)
                    if let pictureData = product.firstImage{
                        cell.imageView?.image = UIImage(data:pictureData)
                    }
                }
                return cell
            }
        }
    }
}
