//
//  PreviewDataTableViewController.swift
//  Factoy
//
//  Created by Mateo Došlić on 07/06/2018.
//  Copyright © 2018 Mateo Došlić. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage


class PreviewDataTableViewController: UITableViewController {

    let cellIdentifier = "PreviewDataTableViewCell"
    let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    fileprivate let newsPresenter = NewsPresenter(newsService: NewsService())
    fileprivate var newsToDisplay = [NewsViewData]()
    
    
    //  Maknuti polje i pristupati preko prezentera
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Factory"
        tableView.register(PreviewDataTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        newsPresenter.attachView(self)
        newsPresenter.getNews()

    }
 
    override func viewDidAppear(_ animated: Bool) {
        newsPresenter.checkTimer(time: Date())
        // prepraviti sa drugom funkcijom
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsToDisplay.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        // Table view cell are used and should be dequeued using a cell identifier
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PreviewDataTableViewCell else
        {
            //fatalError("The dequeued cell is not an instance of MealTableViewCell.")
            errorOccured(value: "The dequeued cell is not an instance of MealTableViewCell.")
            return UITableViewCell()
           
        }
        let newsViewData = newsToDisplay[indexPath.row]
        
        cell.headlineLabel.text = newsViewData.headline
        Alamofire.request(URL (string: newsViewData.imageUrl)!).responseImage
            {
                response in
                    if let image = response.result.value
                    {
                        cell.photoImageView.image = image
                    }
            }
        return  cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newsDetailViewController = DataViewController()
        let selectedNews = newsToDisplay[indexPath.row]
        newsDetailViewController.newsToDisplay = selectedNews
        navigationController?.pushViewController(newsDetailViewController, animated: true)
        
    }
    
}

extension PreviewDataTableViewController: NewsView {
 
    func startLoading() {
        loadingIndicator.center = view.center
        loadingIndicator.color = UIColor.blue
        loadingIndicator.startAnimating()
        view.addSubview(loadingIndicator)
    }
    
    func fininshLoading() {
        loadingIndicator.stopAnimating()
    }
    
    func setNews(_ news: [NewsViewData]) {
        newsToDisplay = news
        tableView.isHidden = false
        tableView.reloadData()
    }
    
    func setEmptyNews() {
        tableView.isHidden = true
        errorOccured(value: "No news has been loaded :(")
    }
    
    
}


