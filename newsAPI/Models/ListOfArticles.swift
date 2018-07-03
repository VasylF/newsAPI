//
//  ArrayoaArticles.swift
//  newsAPI
//
//  Created by Mac on 02.07.18.
//  Copyright © 2018 VasylFuchenko. All rights reserved.
//

import Foundation

class ListOfArticles {
    
    var arrayOfArticles = [Article]()
    
    static let shared = ListOfArticles()
    private init(){}
    
}
