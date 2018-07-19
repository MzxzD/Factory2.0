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


class ListNewsViewController: UITableViewController, NewsViewCellDelegate {

    
    
    let cellIdentifier = "ListNewsViewCell"
    let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    let disposeBag = DisposeBag()
    var refresher: UIRefreshControl!
    var alert = UIAlertController()
    var listNewsViewModel: ListNewsViewModel!
//    var selectedCell: ListNewsViewCell!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ListNewsViewCell.self, forCellReuseIdentifier: cellIdentifier)
        innitializeLoaderObservable()
        initializeDataObservable()
        initializeError()
        listNewsViewModel.initializeObservableDataAPI().disposed(by: disposeBag)
        refreshData()
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
       
        listNewsViewModel.checkForNewData()
        tableView.reloadData()
        // Chech for new data 
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.isMovingFromParentViewController {
            listNewsViewModel.listNewsCoordinatorDelegate?.viewControllerHasFinished()
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listNewsViewModel.newsData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        // Table view cell are used and should be dequeued using a cell identifier
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ListNewsViewCell else
        {
            errorOccured(value: "The dequeued cell is not an instance of PreviewDataTableViewCell.")
            return UITableViewCell()
            
        }
        let newsViewData = listNewsViewModel.newsData[indexPath.row]
        
        cell.newsTitleLabel.text = newsViewData.title
        Alamofire.request(URL (string: (newsViewData.urlToImage)!)!).responseImage
            {
                response in
                if let image = response.result.value
                {
                    cell.newsImageView .image = image
                }
        }
        cell.cellDelegate = self
        cell.favoriteButton.isSelected = newsViewData.isItFavourite
        
        return  cell
    }
    
    func didPressButton(_ sender: ListNewsViewCell) {
        guard let tappedIndexPath = tableView.indexPath(for: sender) else { return }
        print("tapped! index!")
        print(tappedIndexPath)
   
         listNewsViewModel.favoriteButtonPressed(selectedNews: tappedIndexPath.row)
//        listNewsViewModel.combineLocalWithAPIInfomation()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        listNewsViewModel.newsSelected(selectedNews: indexPath.row)
    }
    
    
    @objc func triggerDownload() {
        listNewsViewModel.downloadTrigger.onNext(true)
        
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
    
        let loadingObserver = listNewsViewModel.loaderControll
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
       //             self.listNewsViewModel.combineLocalWithAPIInfomation()

                }
            })
            .disposed(by: disposeBag)
    }
    
    
    func initializeError() {
        let errorObserver = listNewsViewModel.errorOccured
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
        let observer = listNewsViewModel.dataIsReady
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
