//
//  RequestURL.swift
//  shopifyDemo
//
//  Created by Jerry Wang on 3/22/19.
//  Copyright © 2019 Jerry Wang. All rights reserved.
//

import UIKit

extension CustomCollectionsVC{

    func requestMainCollection(){
        
        let session = URLSession.shared
        let url = URL(string:"https://shopicruit.myshopify.com/admin/custom_collections.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6")!        
        let task = session.dataTask(with: url){
            [unowned self](data,response,error) in
            
            guard let responseCode = (response as? HTTPURLResponse)?.statusCode else { return }
            
            if responseCode < 200 || responseCode > 200 {
                print("invalid http status \(responseCode)")
                return
            }
            
            do {
                if let data = data {
                    let results = try JSONDecoder().decode(MainCollectionResponse.self, from: data)
                    self.mainCollection = results
                    DispatchQueue.main.async {
                        [unowned self] in
                        self.tableView.reloadData()
                    }
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
    
    
}
