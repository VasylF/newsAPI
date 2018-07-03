//
//  FetchProfile.swift
//  newsAPI
//
//  Created by Mac on 29.06.18.
//  Copyright © 2018 VasylFuchenko. All rights reserved.
//

import Foundation
import Alamofire

class News {
    
    let url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=170b0a6e7cbc4c45a21f4f13a27d2303"
    static let shared = News()
    private init(){}
    
    func getNews(tableView: UITableView) {
        Alamofire.request(url).responseJSON { response in
            print(response)
            guard let newsFileJSON = response.result.value,
                let newsObject = newsFileJSON as? [String: AnyObject],
                let articlesObject = newsObject["articles"] as? [[String: AnyObject]] else {
                   UIViewController.presentAlert(title: "Error", message: "Cannot parse data", completion: nil)
                    return
            }
            print(articlesObject)
            for value in articlesObject {
                guard let title = value["title"] as? String,
                    let desc = value["description"] as? String,
                    let url = value["url"] as? String,
                    let author = value["author"] as? String,
                    let urlToImage = value["urlToImage"] as? String,
                    let sourseObject = value["source"] as? [String: Any],
                    let source = sourseObject["name"] as? String else {continue}
                ListOfArticles.shared.arrayOfArticles.append(Article(title: title, desc: desc, url: url, urlToImage: urlToImage, author: author, source: source))
            }
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        }
    }
    
}
