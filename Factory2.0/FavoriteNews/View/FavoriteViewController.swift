//
//  FavoriteViewController.swift
//  Factory2.0
//
//  Created by Mateo Došlić on 11/07/2018.
//  Copyright © 2018 Mateo Došlić. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import RxSwift

class FavoriteViewController: UITableViewController {

    let cellIdentifier = "ListNewsViewCell"
    let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    let disposeBag = DisposeBag()
    var refresher: UIRefreshControl!
    var alert = UIAlertController()
    var listViewModel: ListNewsViewModel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        let newModel = ListNewsViewModel(newsService: APIRepository())
        self.listViewModel = newModel
        tableView.register(ListNewsViewCell.self, forCellReuseIdentifier: cellIdentifier)
        innitializeLoaderObservable()
        initializeDataObservable()
        initializeError()
        listViewModel.initializeObservableDataAPI().disposed(by: disposeBag)
        refreshData()
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        listViewModel.checkForNewData()
        // Chech for new data
        
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // if self.isMovingToParentViewController {
        listViewModel.listNewsCoordinatorDelegate?.viewControllerHasFinished()
        // }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.newsData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        // Table view cell are used and should be dequeued using a cell identifier
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ListNewsViewCell else
        {
            errorOccured(value: "The dequeued cell is not an instance of PreviewDataTableViewCell.")
            return UITableViewCell()
            
        }
        let newsViewData = listViewModel.newsData[indexPath.row]
        
        cell.newsTitle.text = newsViewData.title
        Alamofire.request(URL (string: (newsViewData.urlToImage))!).responseImage
            {
                response in
                if let image = response.result.value
                {
                    cell.newsImage.image = image
                }
        }
        return  cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        let newsViewController = NewsViewController()
        //        let newsPresenter = NewsViewModel()
        //        let selectedNews = newTableVieMode.newsArray[indexPath.row]
        //        newsPresenter.newsData = selectedNews
        //        newsViewController.modelView = newsPresenter
        //        navigationController?.pushViewController(newsViewController, animated: true)
        
        listViewModel.newsSelected(selectedNews: indexPath.row)
    }
    
    
    @objc func triggerDownload() {
        listViewModel.downloadTrigger.onNext(true)
        
    }
    
    func refreshData() {
        
        refresher = UIRefreshControl()
        tableView.addSubview(refresher)
        refresher.attributedTitle = NSAttributedString(string: "Refreshing")
        refresher.tintColor = UIColor(red: 0, green: 0.6, blue: 0.949, alpha: 1.0)
        refresher.addTarget(self, action: #selector(triggerDownload), for: .valueChanged)
        initializeError()
    }
    
    
    func innitializeLoaderObservable() {
        
        let loadingObserver = listViewModel.loaderControll
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
                    //                    self.loadingIndicator.removeFromSuperview()
                }
            })
            .disposed(by: disposeBag)
    }
    
    
    func initializeError() {
        let errorObserver = listViewModel.errorOccured
        errorObserver
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (event) in
                if event {
                    self.loadingIndicator.stopAnimating()
                    self.refresher.endRefreshing()
                    self.refresher.isHidden = true
                    print("Event triggered")
                    downloadError(viewToPresent: self)
                } else {
                    print("Event Not triggered")
                }
            })
            .disposed(by: disposeBag)
        //        errorOccured(value: )
    }
    
    func initializeDataObservable(){
        let observer = listViewModel.dataIsReady
        observer
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (event) in
                
                if event {
                    self.tableView.reloadData()
                    self.refresher.endRefreshing()
                }
                
            })
            .disposed(by: disposeBag)
    }
    
    
    
    
}






















   

    








