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
import RxSwift


class NewsTableViewController: UITableViewController {
    
    let cellIdentifier = "PreviewDataTableViewCell"
    let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    let disposeBag = DisposeBag()
    
    fileprivate let newsTablePresenter = NewsTablePresenter(newsService: NewsDataService())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Factory"
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        createLoadingIndicator()
        isDataReady()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        newsTablePresenter.checkForNewData()
        
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsTablePresenter.newsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        // Table view cell are used and should be dequeued using a cell identifier
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? NewsTableViewCell else
        {
            errorOccured(value: "The dequeued cell is not an instance of PreviewDataTableViewCell.")
            return UITableViewCell()
            
        }
        let newsViewData = newsTablePresenter.newsArray[indexPath.row]
        
        cell.headlineLabel.text = newsViewData.title
        Alamofire.request(URL (string: (newsViewData.urlToImage))!).responseImage
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
        let newsViewController = NewsViewController()
        let newsPresenter = NewsPresenter()
        let selectedNews = newsTablePresenter.newsArray[indexPath.row]
        newsPresenter.newsData = selectedNews
        newsViewController.Presenter = newsPresenter
        navigationController?.pushViewController(newsViewController, animated: true)
        
    }
    
    
    func createLoadingIndicator() {
        loadingIndicator.center = view.center
        loadingIndicator.color = UIColor.blue
        loadingIndicator.startAnimating()
        view.addSubview(loadingIndicator)
        
    }
    
    func isDataReady(){
        let observer = newsTablePresenter.newsSubject
        observer
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (event) in
                guard let _self = self else { return }
                if event {
                    _self.tableView.reloadData()
                    _self.loadingIndicator.stopAnimating()
                }
            })
            .disposed(by: disposeBag)
    }
    
    
}
