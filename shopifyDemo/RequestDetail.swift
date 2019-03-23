//
//  RequestSingleCollection.swift
//  shopifyDemo
//
//  Created by Jerry Wang on 3/23/19.
//  Copyright © 2019 Jerry Wang. All rights reserved.
//

import UIKit

extension CollectionDetailVC{
    
    func requestPicture(){
        guard let url = URL(string:collectionItem.image.src) else { return }
        let session = URLSession.shared
        
        let task = session.dataTask(with: url){
            [weak self](data,response,error) in
            guard let responseCode = (response as? HTTPURLResponse)?.statusCode else { return }
            if responseCode < 200 || responseCode > 200 {
                print("invalid http status \(responseCode)")
                return
            }
            if let data = data {
                self?.collectionImage = UIImage(data:data)
                DispatchQueue.main.async{
                    [weak self] in 
                    self?.tableView.reloadData()
                }
            }
            if let error = error {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func requestDetail(collectionID:Int){
        guard let url = URL(string: "https://shopicruit.myshopify.com/admin/collects.json?collection_id=\(collectionID)&page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6") else { return }
        let session = URLSession.shared
        
        let task = session.dataTask(with: url){
            [weak self](data,response,error) in
            guard let responseCode = (response as? HTTPURLResponse)?.statusCode else { return }
            if responseCode < 200 || responseCode > 200 {
                print("invalid http status \(responseCode)")
                return
            }

            do {
                if let data = data {
                    
                    let results = try JSONDecoder().decode(SingleCollectionResponse.self, from: data)
                    
                    self?.requestProducts(productIDs: results.collects.map {$0.product_id})
                }
            } catch {
                print("couldn't serialize data into JSON")
            }
            
            if let error = error {
                print(error.localizedDescription)
            }            
        }
        task.resume()
    }
    
    func requestProducts(productIDs:[Int]){
        let ids = productIDs.map {String($0)}.joined(separator: ",")
        guard let url = URL(string: "https://shopicruit.myshopify.com/admin/products.json?ids=\(ids)&page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6") else { return }
        let session = URLSession.shared
        
        
        let task = session.dataTask(with: url){
            (data,response,error) in
            guard let responseCode = (response as? HTTPURLResponse)?.statusCode else { return }
            if responseCode < 200 || responseCode > 200 {
                print("invalid http status \(responseCode)")
                return
            }
            if let error = error {
                print(error.localizedDescription)
            }
            
            do {
                if let data = data {
                    let products = try JSONDecoder().decode(ProductResponse.self, from: data)
                    self.productItems = products.products

                    DispatchQueue.main.async{
                        [weak self] in
                        self?.tableView.reloadData()
                    }
                }
            }catch{
                print("could not convert to JSON!")
            }
            
        }
        task.resume()
    }
}
