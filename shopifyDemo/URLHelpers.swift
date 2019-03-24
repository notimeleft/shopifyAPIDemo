//
//  EnumHelpers.swift
//  shopifyDemo
//
//  Created by Jerry Wang on 3/23/19.
//  Copyright © 2019 Jerry Wang. All rights reserved.
//

import Foundation

//a collection of raw string values to be used for constructing http requests

func MainRequestURL()->URL?{
    return URL(string:"https://shopicruit.myshopify.com/admin/custom_collections.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6")
}
func CollectionRequestURL(id:Int)->URL?{
    return URL(string:"https://shopicruit.myshopify.com/admin/collects.json?collection_id=\(id)&page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6")
}
func ProductRequestURL(id:String)->URL?{
    return URL(string: "https://shopicruit.myshopify.com/admin/products.json?ids=\(id)&page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6")
}


