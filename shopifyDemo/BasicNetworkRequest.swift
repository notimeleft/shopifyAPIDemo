//
//  RequestURL.swift
//  shopifyDemo
//
//  Created by Jerry Wang on 3/22/19.
//  Copyright © 2019 Jerry Wang. All rights reserved.
//

import UIKit

//a basic network request that requests data from a URL and handles the data via a closure param. The data handler might fail, so it's labeled with 'throws'
func basicNetworkRequest(url:URL, dataHandler:@escaping(Data) throws -> Void){
    URLSession.shared.dataTask(with: url){
        (data,response,error) in
        guard let responseCode = (response as? HTTPURLResponse)?.statusCode else { return }
        if responseCode < 200 || responseCode > 200 {
            print("invalid http status \(responseCode)")
            return
        }
        if let data = data {
            do {
                try dataHandler(data)
            } catch {
                print("failed to handle data properly")
            }
        }
        if let error = error {
            print(error.localizedDescription)
        }
        }.resume()
}

