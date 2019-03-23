//
//  JSONStructs.swift
//  shopifyDemo
//
//  Created by Jerry Wang on 3/22/19.
//  Copyright © 2019 Jerry Wang. All rights reserved.
//

import UIKit

//structs of the dictionary values we expect to receive from JSON responses

//nest the json structures so that we don't accidently refer to one sub-struct that belongs to another main response struct
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


struct SingleCollectionResponse:Codable{
    
    let collects:[Collect]
    
    struct Collect:Codable{
        let product_id:Int
    }
}


struct ProductResponse:Codable{
    
    let products:[Product]
    
    struct Product:Codable{
        let title:String
        let variants:[Variant]
        struct Variant:Codable{
            let inventory_quantity:Int
        }
        var quantity:Int{return self.variants.reduce(0){$0+$1.inventory_quantity}}
        let images:[ImageLink]
        struct ImageLink:Codable{
            let src:String
        }
    }
}
