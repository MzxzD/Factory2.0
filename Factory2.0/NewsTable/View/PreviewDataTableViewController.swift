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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Factory"
        tableView.register(PreviewDataTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        newsPresenter.attachView(self)
        newsPresenter.getNews()

    }
 
    override func viewDidAppear(_ animated: Bool) {
        newsPresenter.checkTimer()
    
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsPresenter.newsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        // Table view cell are used and should be dequeued using a cell identifier
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PreviewDataTableViewCell else
        {
            errorOccured(value: "The dequeued cell is not an instance of PreviewDataTableViewCell.")
            return UITableViewCell()
           
        }
        let newsViewData = newsPresenter.newsArray[indexPath.row]
        
        cell.headlineLabel.text = newsViewData?.title
        Alamofire.request(URL (string: (newsViewData?.urlToImage)!)!).responseImage
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
        let newsDetailPresenter = NewsDetailPresenter()
        let selectedNews = newsPresenter.newsArray[indexPath.row]
        newsDetailPresenter.newsDetailData = selectedNews
        newsDetailViewController.detailPresenter = newsDetailPresenter
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
    
    func setNews() {
        tableView.isHidden = false
        tableView.reloadData()
    }
    
    func setEmptyNews() {
        tableView.isHidden = true
        errorOccured(value: "No news has been loaded :(")
    }
    
    
}


