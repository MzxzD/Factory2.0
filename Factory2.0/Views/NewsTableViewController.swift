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
    
    let cellIdentifier = "NewsTableViewCell"
    let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    let disposeBag = DisposeBag()
   
    
    fileprivate let newsTableViewMode = NewsTableViewModel(newsService: NewsDataService())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Factory"
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        innitializeLoaderObservable()
        initializeDataObservable()
        
        newsTableViewMode.initializeObservableDataAPI().disposed(by: disposeBag)
        refreshData()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        newsTableViewMode.checkForNewData()
        //newsTableViewMode.dummyDownload()
        // Chech for new data 
        
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsTableViewMode.newsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        // Table view cell are used and should be dequeued using a cell identifier
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? NewsTableViewCell else
        {
            errorOccured(value: "The dequeued cell is not an instance of PreviewDataTableViewCell.")
            return UITableViewCell()
            
        }
        let newsViewData = newsTableViewMode.newsArray[indexPath.row]
        
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
        let newsPresenter = NewsViewModel()
        let selectedNews = newsTableViewMode.newsArray[indexPath.row]
        newsPresenter.newsData = selectedNews
        newsViewController.modelView = newsPresenter
        navigationController?.pushViewController(newsViewController, animated: true)
        
    }
    
    
    func refreshData() {
        var refresher: UIRefreshControl!
        refresher = UIRefreshControl()
        tableView.addSubview(refresher)
        refresher.attributedTitle = NSAttributedString(string: "Refreshing")
        refresher.tintColor = UIColor(red: 0, green: 0.6, blue: 0.949, alpha: 1.0)
       // refresher.addTarget(self, action: #selector(newsTableViewMode.initializeObservableDataAPI), for: .valueChanged)
    }
    
    
    func innitializeLoaderObservable() {
    
        let loadingObserver = newsTableViewMode.isLoading
        loadingObserver.asObservable()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (event) in
                
                if (event) {
                    self.loadingIndicator.center = self.view.center
                    self.loadingIndicator.color = UIColor.blue
                    self.view.addSubview(self.loadingIndicator)
                    self.loadingIndicator.startAnimating()
                    print("Loader Initialised!")
                } else{
                    self.loadingIndicator.stopAnimating()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func initializeDataObservable(){
        let observer = newsTableViewMode.refreshView
        observer
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (event) in
                
                if event {
                    self.tableView.reloadData()
                }

            })
            .disposed(by: disposeBag)
    }
    
    
}
