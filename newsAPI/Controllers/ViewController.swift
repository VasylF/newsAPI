//
//  ViewController.swift
//  newsAPI
//
//  Created by Mac on 26.06.18.
//  Copyright © 2018 VasylFuchenko. All rights reserved.

import UIKit
import SafariServices

enum Selected: Int {
    case category = 0
    case country = 1
    case sources = 2
}

class ViewController: UIViewController {
  
    @IBOutlet weak var tableView: UITableView!
    
    lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(ViewController.updateData(_:)), for: .valueChanged)
        refresh.tintColor = UIColor.brown
        return refresh
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        News.shared.getNews(tableView: self.tableView)
        self.tableView.addSubview(self.refreshControl)
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width), height: 70))
        searchBar.barTintColor = UIColor.black
        searchBar.showsScopeBar = true
        searchBar.scopeButtonTitles = ["category","country", "sources"]
        searchBar.delegate = self
        self.tableView.tableHeaderView = searchBar
        self.tableView.reloadData()
    }
    
    func updateSearchResults(searchController: UISearchController) {
        ListOfArticles.shared.arrayOfArticles = ListOfArticles.shared.arrayOfArticles.filter( {(article: Article) -> Bool in
            if (article.desc?.contains(searchController.searchBar.text!))! {
                return true
            } else {
                return false
            }
        })
    }
    
    @objc func updateData(_ refreshControl: UIRefreshControl) {
        ListOfArticles.shared.arrayOfArticles = [Article]()
        News.shared.getNews(tableView: self.tableView)
        refreshControl.endRefreshing()
    }
    
}


//MARK: extension

extension ViewController: SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ListOfArticles.shared.arrayOfArticles.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = ListOfArticles.shared.arrayOfArticles[indexPath.row]
        let url = article.url
        showWebSite(url: url!)
    }
    
    func showWebSite(url: String) {
        let safariVC = SFSafariViewController(url: NSURL(string: url)! as URL)
        self.present(safariVC, animated: true, completion: nil)
        safariVC.delegate = self
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellNews") as! NewsCell
        cell.title.text = ListOfArticles.shared.arrayOfArticles[indexPath.row].title
        cell.desc.text = ListOfArticles.shared.arrayOfArticles[indexPath.row].desc
        cell.auther.text = ListOfArticles.shared.arrayOfArticles[indexPath.row].author
        cell.url.text = ListOfArticles.shared.arrayOfArticles[indexPath.row].url
        cell.viewImage.downloadImage(url: (ListOfArticles.shared.arrayOfArticles[indexPath.row].imageUrl!))
        return cell
    }
   
}


extension UIViewController {
    
    static func presentAlert(title: String? = nil,
                             message: String? = nil,
                             actions: [UIAlertAction] = [],
                             completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if actions.count == 0 {
            alert.addAction(UIAlertAction.init(title: "ok", style: .default, handler: {_ in completion?()}))
        } else {
            for action in actions {
                alert.addAction(action)
            }
        }
    }
    
}


extension UIImageView {
    
    func downloadImage(url: String) {
        let urlRequest = URLRequest(url: URL(string: url)!)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
        task.resume()
    }
    
}

extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            News.shared.getNews(tableView: self.tableView)
        } else {
        filterTableView(index: searchBar.selectedScopeButtonIndex, searchBarText: searchText)
        }
    }
    
    func filterTableView(index: Int, searchBarText: String) {
        switch index {
        case Selected.category.rawValue:
            ListOfArticles.shared.arrayOfArticles = ListOfArticles.shared.arrayOfArticles.filter { (article) -> Bool in
                return (article.title?.lowercased().contains(searchBarText.lowercased()))!
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        case Selected.country.rawValue:
            ListOfArticles.shared.arrayOfArticles = ListOfArticles.shared.arrayOfArticles.filter { (article) -> Bool in
                return (article.desc?.lowercased().contains(searchBarText.lowercased()))!
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        case Selected.sources.rawValue:
            ListOfArticles.shared.arrayOfArticles = ListOfArticles.shared.arrayOfArticles.filter { (article) -> Bool in
                return (article.source?.lowercased().contains(searchBarText.lowercased()))!
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        default:
            print("No such")
        }
        
    }
    
    
}







