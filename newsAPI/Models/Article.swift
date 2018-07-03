//
//  Article.swift
//  newsAPI
//
//  Created by Mac on 28.06.18.
//  Copyright © 2018 VasylFuchenko. All rights reserved.
//

import Foundation

class Article{
    
    var title : String?
    var desc : String?
    var url : String?
    var imageUrl : String?
    var author: String?
    var publishedAt: String?
    var source: String?
    
    
    init(title: String, desc: String, url: String, urlToImage: String, author: String, source: String) {
        self.title = title
        self.desc = desc
        self.url = url
        self.imageUrl = urlToImage
        self.author = author
        self.source = source
    }
    
}
