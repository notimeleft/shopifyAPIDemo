//
//  JSONStructs.swift
//  shopifyDemo
//
//  Created by Jerry Wang on 3/22/19.
//  Copyright © 2019 Jerry Wang. All rights reserved.
//

import UIKit

//nested structs of the dictionary values we expect to receive from JSON responses

//a list of collections, each with title,body,id and image
struct MainCollectionResponse:Codable{
    
    let custom_collections:[CollectionItem]
    
    struct CollectionItem:Codable{
        
        let title:String
        let body_html:String
        let id:Int
        let image:Image
        
        struct Image:Codable{
            let src:String
        }
    }
}

//a single collection's list of product ids
struct SingleCollectionResponse:Codable{
    
    let collects:[Collect]
    
    struct Collect:Codable{
        let product_id:Int
    }
}

//a list of products each with title,variant,quantity and image
//Hey Wait a minute....Why is ProductResponse a class you say?!
//Well...long story short, we want to be able to modify the value of a product object in an array (to set its image data), and if it were a value type, this would not be easy to do. 
class ProductResponse:Codable{
    
    var products:[Product]
    
    class Product:Codable{
        var title:String
        let variants:[Variant]
        class Variant:Codable{
            let inventory_quantity:Int
        }
        var quantity:Int{return self.variants.reduce(0){$0+$1.inventory_quantity}}
        let images:[ImageLink]
        class ImageLink:Codable{
            let src:String
        }
        var firstImage:Data?
    }
}
